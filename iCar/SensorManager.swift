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
    
    lazy var motionManager: CMMotionManager! = {
        let manager = CMMotionManager()
        
        
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
    
    func isRecording() -> Bool {
        return currentRide != nil
    }
    
    func startRide(ride: Ride) {
        currentRide = ride
        
        currentRide?.startDate = NSDate()
        
        motionManager.startAccelerometerUpdates()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopRide() -> Ride {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
        motionManager.stopAccelerometerUpdates()
        
        currentRide?.endDate = NSDate()
        
        AppDelegate.sharedAppDelegate.saveContext()
        
        let tmpRide = currentRide!
        
        currentRide = nil
        
        return tmpRide
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading ?? newHeading.magneticHeading
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let ride = currentRide {
            createRidePoint(ride, heading: heading, location: locations.last)
        }
    }
    
    private func createRidePoint(ride:Ride, heading:Double?, location:CLLocation?) {
        print("loc: \(location?.coordinate.latitude) @ \(location?.coordinate.longitude), heading: \(heading ?? -Double.infinity)")
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
        
        // if the iphone is facing the Z direction pointing upwards along the Y, in portrait mode
        var accFrontal = motionManager.accelerometerData?.acceleration.z ?? -Double.infinity
        var accLateral = motionManager.accelerometerData?.acceleration.x ?? -Double.infinity
        
        point.accFrontal = accFrontal
        point.accLateral = accLateral
    }
}

protocol SensorManagerDelegate {
    func onSensorUpdate()
}