//
//  MapPointAnnotation.swift
//  iCar
//
//  Created by Gergely Kőrössy on 09/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import Foundation
import MapKit

class MapPointAnnotation:NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    var title: String?
    var subtitle: String?
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}