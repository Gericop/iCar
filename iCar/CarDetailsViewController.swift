//
//  CarDetailsViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 08/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import CoreData

class CarDetailsViewController: UIViewController {

    @IBOutlet weak var carName: UITextField!
    @IBOutlet weak var carLicensePlate: UITextField!
    @IBOutlet weak var carColor: CarColorPicker!
    
    var car : Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let c = car {
            carName.text = c.name
            carLicensePlate.text = c.licensePlate
            
            if let rowColor = c.rowColor {
                carColor.setSelected(Int(rowColor))
            }
        }
    }
    

    @IBAction func saveButtonTap(sender: AnyObject) {
        
        if checkFields() {
            if let c = car {
                updateCar(c)
            } else {
                createCar()
            }
        
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func checkFields() -> Bool {
        if carName.text != "" && carLicensePlate.text != "" {
            return true
        }
        
        let alert = UIAlertController(title: "Error", message:
            "The fields cannot be empty!", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel,
            handler: nil)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
        return false
    }
    
    func updateCar(c:Car) {
        c.name = carName.text
        c.licensePlate = carLicensePlate.text
        c.rowColor = carColor.getSelectedColor()
        
        AppDelegate.sharedAppDelegate.saveContext()
    }
    
    func createCar() {
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Car",
            inManagedObjectContext: moc)
        
        let c = Car(entity: entity!,
            insertIntoManagedObjectContext:moc)
        
        updateCar(c)
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
