//
//  Ride+CoreDataProperties.swift
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

extension Ride {

    @NSManaged var distance: NSNumber?
    @NSManaged var endDate: NSDate?
    @NSManaged var startDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var car: Car?
    @NSManaged var points: NSSet?

}
