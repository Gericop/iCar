//
//  Car+CoreDataProperties.swift
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

extension Car {

    @NSManaged var licensePlate: String?
    @NSManaged var enabled: NSNumber?
    @NSManaged var rowColor: NSNumber?
    @NSManaged var name: String?
    @NSManaged var refilllogs: NSSet?
    @NSManaged var rides: NSSet?

}
