//
//  RideDetailsViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 09/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import CoreData

class RideDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    
    var ride : Ride!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = ride.title
        
        let car = ride.car!
        
        carLabel.text = "\(car.name!) [\(car.licensePlate!)]"
        
        if ride.endDate == nil {
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditRide" {
            let detailsVC = segue.destinationViewController as! RideEditorViewController
            
            detailsVC.ride = ride
        } else if segue.identifier == "MapSegue" {
            let mapVC = segue.destinationViewController as! RideMapViewController
            
            mapVC.ride = ride
        }
    }
    

}
