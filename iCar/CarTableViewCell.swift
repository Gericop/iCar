//
//  CarTableViewCell.swift
//  iCar
//
//  Created by Gergely Kőrössy on 07/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    
    @IBOutlet weak var enablerSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var licensePlateLabel: UILabel!
    
    var car : Car!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func carEnablerChanged(sender: AnyObject) {
        car.enabled = enablerSwitch.on
        AppDelegate.sharedAppDelegate.saveContext()
    }
}
