//
//  RidePoint+CoreDataProperties.swift
//  iCar
//
//  Created by Gergely Kőrössy on 07/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RidePoint {

    @NSManaged var accFrontal: NSNumber?
    @NSManaged var accLateral: NSNumber?
    @NSManaged var altitude: NSNumber?
    @NSManaged var bearing: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var lon: NSNumber?
    @NSManaged var speed: NSNumber?
    @NSManaged var time: NSDate?
    @NSManaged var ride: NSManagedObject?

}
