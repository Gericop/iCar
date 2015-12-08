//
//  SensorManager.swift
//  iCar
//
//  Created by Gergely Kőrössy on 08/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion
import CoreData

class SensorManager:NSObject, CLLocationManagerDelegate {
    static let instance = SensorManager()
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    func getSingleLocation() {
        
    }
    
    func startRide() {
        
    }
    
    func stopRide() {
        
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        /*// Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate
        
        // Also add to our map so we can remove old values later
        locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = locations.first!
            locations.removeAtIndex(0)
            
            // Also remove from the map
            mapView.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.sharedApplication().applicationState == .Active {
            mapView.showAnnotations(locations, animated: true)
        } else {
            NSLog("App is backgrounded. New location is %@", newLocation)
        }*/
    }
}

protocol SensorManagerDelegate {
    func onSensorUpdate()
}