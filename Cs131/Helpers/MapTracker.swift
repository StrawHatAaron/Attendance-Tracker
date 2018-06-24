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
    var studentInRightLocation:Bool = false
    var latitude:Double = 0.0
    var longitude:Double = 0.0

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
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = locValue.latitude
        longitude = locValue.longitude
        print("locations = \(latitude) \(longitude)")
        //TODO - find a nice radius for this(:
        if  latitude  >= -100.0 || latitude  <= 100.0 &&
            longitude >= -100.0 || longitude <= 100.0 {
                canTrackStudent = true
        }
    }
}

