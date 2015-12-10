//
//  RideEditorViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 10/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import CoreData

class RideEditorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var carPicker: UIPickerView!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var ride: Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCars()
        
        carPicker.delegate = self
        carPicker.dataSource = self

        if let r = ride {
            titleField.text = r.title
            
            initCarPicker()
            
            self.navigationItem.rightBarButtonItem?.title = "Save"
        } else {
            if !SensorManager.getManager().isLocationAvailable() {
                self.navigationItem.prompt = "Enable location services!"
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchCars()
        super.viewWillAppear(animated)
    }
    
    @IBAction func startRideButtonTap(sender: AnyObject) {
        if let r = ride {
            // save update
        } else {
            // start location updates
            //SensorManager.getManager().startRide(ride: Ride)
        }
    }
    
    func initCarPicker() {
        if ride == nil {
            return
        }
        
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        //let car = ride?.car as! Car
        let car = ride?.car!
        
        for var i = 0; i < count; i++ {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let fetchedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Car
            
            if fetchedObject.licensePlate == car!.licensePlate {
                carPicker.selectRow(i, inComponent: 0, animated: false)
                break
            }
        }
    }
    
    // PICKER VIEW THINGS
    
    func fetchCars() {
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Car")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        fetchedResultsController.delegate = self
    }
    
    //size the components of the UIPickerView
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20.0
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        let fetchedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Car
        
        return "\(fetchedObject.name!) [\(fetchedObject.licensePlate!)]"
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
