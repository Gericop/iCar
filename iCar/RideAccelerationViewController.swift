//
//  RideAccelerationViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 17/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit

class RideAccelerationViewController: UIViewController {
    @IBOutlet weak var accelView: AccelerationView!
    
    var ride: Ride!

    override func viewDidLoad() {
        super.viewDidLoad()

        accelView.setRide(ride)
    }

}
