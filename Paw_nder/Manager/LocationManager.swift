//
//  LocationManager.swift
//  Paw_nder
//
//  Created by William Yeung on 5/25/21.
//

import Foundation
import CoreLocation
import Firebase

class LocationManager {
    // MARK: - Properties
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    
    var hasPreviouslySavedLocation: Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return false }
        return UserDefaults.standard.bool(forKey: currentUserId)
    }
    
    // MARK: - Helpers
    func checkLocationServices(delegate: CLLocationManagerDelegate, completion: @escaping (Error?) -> ()) {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager(delegate: delegate)
            checkLocationAuthorization(completion: completion)
        } else {
            debugPrint("location service disabled")
        }
    }
    
    func setupLocationManager(delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        locationManager.distanceFilter = 1609.34 * 3
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func saveUserLocation(completion: @escaping (Error?) -> ()) {
        guard let location = locationManager.location else { return }

        location.cityAndStateName { cityAndStateName, error in
            if let error = error {
                completion(error)
            }
            
            let currentUserId = Auth.auth().currentUser?.uid ?? ""
            let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            Firestore.firestore().collection(Firebase.users).document(currentUserId).updateData(["location": ["name": cityAndStateName ?? "", "coord": geoPoint]]) { error in
                if let error = error {
                    completion(error)
                    return
                }

                UserDefaults.standard.setValue(true, forKey: currentUserId)
                completion(nil)
            }
        }
    }
    
    func removeUserLocation(completion: @escaping (Error?) -> Void) {
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        
        Firestore.firestore().collection(Firebase.users).document(currentUserId).updateData(["location": FieldValue.delete()]) { error in
            if let error = error {
                completion(error)
                return
            }

            UserDefaults.standard.setValue(false, forKey: currentUserId)
            completion(nil)
        }
    }

    func checkLocationAuthorization(completion: @escaping (Error?) -> ()) {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
                if !hasPreviouslySavedLocation { saveUserLocation(completion: completion) }
            case .restricted, .denied:
                locationManager.stopUpdatingLocation()
                if hasPreviouslySavedLocation { removeUserLocation(completion: completion) }
            @unknown default:
                break
        }
    }
}
