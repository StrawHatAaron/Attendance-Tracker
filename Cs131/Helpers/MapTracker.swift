//
//  MapTracker.swift
//  Cs131
//
//  Created by Aaron Miller on 6/4/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import Foundation
import MapKit

public class MapTracker:CLLocationManager, CLLocationManagerDelegate {


    let locationManager = CLLocationManager()
    var canTrackStudent:Bool = false

    //return true if student is in the correct place
    public func trackStudent() -> Bool{
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        print("canTrackStudent: \(canTrackStudent)")
        return canTrackStudent
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        canTrackStudent = true
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

