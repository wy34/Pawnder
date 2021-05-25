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
        return UserDefaults.standard.bool(forKey: "location")
    }
    
    // MARK: - Helpers
    func checkLocationServices(delegate: CLLocationManagerDelegate, completion: @escaping (Error?) -> ()) {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager(delegate: delegate)
            checkLocationAuthorization(completion: completion)
        } else {
            print("handle location service disabled")
        }
    }
    
    func setupLocationManager(delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func saveUserLocation(completion: @escaping (Error?) -> ()) {
        guard let location = locationManager.location else { return }
        
        location.cityAndStateName { cityAndStateName, error in
            if let error = error {
                print(error)
            }
            
            let currentUserId = Auth.auth().currentUser?.uid ?? ""
            let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            Firestore.firestore().collection("users").document(currentUserId).updateData(["location": ["name": cityAndStateName, "coord": geoPoint]]) { error in
                if let error = error {
                    completion(error)
                    return
                }

                UserDefaults.standard.setValue(true, forKey: "location")
                completion(nil)
            }
        }
    }

    func checkLocationAuthorization(completion: @escaping (Error?) -> ()) {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                if !hasPreviouslySavedLocation { saveUserLocation(completion: completion) }
            case .restricted, .denied, .authorizedAlways:
                #warning("need to show Location Unavailable")
                break
            @unknown default:
                break
        }
    }
}
