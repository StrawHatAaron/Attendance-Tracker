//: Playground - noun: a place where people can play

import UIKit


func getStateAndCountry(callback:@escaping ([String])->()) {
    let locationManager = CLLocationManager()
    //var stateAndCountry:[String] = []
    if locationServiceIsOn() {
        CLGeocoder().reverseGeocodeLocation(locationManager.location!) { (placemark, error) in
            if error != nil {
                print("error")
            } else {
                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    
                    callback([place.administrativeArea!, place.country!])
                }
            }
        }
    }
}

func getStateAndCountry(callback:@escaping ()->([String])) {
    let locationManager = CLLocationManager()
    //var stateAndCountry:[String] = []
    if locationServiceIsOn() {
        CLGeocoder().reverseGeocodeLocation(locationManager.location!) { (placemark, error) in
            if error != nil {
                print("error")
            } else {
                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    
                    
                }
            }
        }
    }
}
