//
//  CLLocation.swift
//  Paw_nder
//
//  Created by William Yeung on 5/25/21.
//

import CoreLocation

extension CLLocation {
    func cityAndStateName(completion: @escaping (String?, Error?) -> ()) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(self) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let placemark = placemarks?.first {
                let cityStateName = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
                completion(cityStateName, nil)
                return
            }
            
            completion(nil, nil)
        }
    }
}
