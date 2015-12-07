//
//  RefillLog+CoreDataProperties.swift
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

extension RefillLog {

    @NSManaged var altitude: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var lon: NSNumber?
    @NSManaged var refillQnty: NSNumber?
    @NSManaged var time: NSDate?
    @NSManaged var type: String?
    @NSManaged var unitPrice: NSNumber?
    @NSManaged var odometer: NSNumber?
    @NSManaged var car: NSManagedObject?

}
