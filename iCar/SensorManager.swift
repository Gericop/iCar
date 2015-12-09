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
    private static let instance:SensorManager = SensorManager()
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    var currentRide: Ride?
    
    var heading: Double?
    
    class func getManager() -> SensorManager {
        return instance
    }
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func isLocationAvailable() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        
        return status == .AuthorizedAlways
    }
    
    func startRide(ride: Ride) {
        currentRide = ride
        
        currentRide?.startDate = NSDate()
        
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    func stopRide() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        
        currentRide?.endDate = NSDate()
        
        AppDelegate.sharedAppDelegate.saveContext()
        
        currentRide = nil
    }
    
    // MARK: - CLLocationManagerDelegate
    
    /*func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        // Add another annotation to the map.
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
        }
    }*/
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading ?? newHeading.magneticHeading
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let ride = currentRide {
            createRidePoint(ride, heading: heading, location: locations.last)
        }
    }
    
    private func createRidePoint(ride:Ride, heading:Double?, location:CLLocation?) {
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("RidePoint", inManagedObjectContext: moc)
        
        let point = RidePoint(entity: entity!, insertIntoManagedObjectContext:moc)
        
        point.ride = ride
        point.bearing = heading ?? -Double.infinity
        point.lat = location?.coordinate.latitude ?? -Double.infinity
        point.lon = location?.coordinate.longitude ?? -Double.infinity
        point.altitude = location?.altitude ?? -Double.infinity
        point.speed = location?.speed ?? -Double.infinity
        point.time = location?.timestamp ?? NSDate()
        
        point.accFrontal = 0
        point.accLateral = 0
    }
}

protocol SensorManagerDelegate {
    func onSensorUpdate()
}