//
//  RideMapViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 10/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class RideMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var ride: Ride!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = ride.title
        let points = ride.points?.allObjects as! [RidePoint]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        
        for p in points {
            let mapAnnotation = MapPointAnnotation()
            let coords = CLLocationCoordinate2DMake(CLLocationDegrees(p.lat!), CLLocationDegrees(p.lon!))
            mapAnnotation.setCoordinate(coords)
            mapAnnotation.title = "\(Double(p.speed!) * 3.6) km/h"
            mapAnnotation.subtitle = dateFormatter.stringFromDate(p.time!)
            mapView.addAnnotation(mapAnnotation)
            mapView.centerCoordinate = coords
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
