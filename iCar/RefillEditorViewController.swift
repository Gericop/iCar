//
//  RefillEditorViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 08/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class RefillEditorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController!
    
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var refillType: UITextField!
    
    @IBOutlet weak var carPicker: UIPickerView!
    
    @IBOutlet weak var locationMapView: MKMapView!
    
    var refillLog : RefillLog?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carPicker.delegate = self
        carPicker.dataSource = self
        
        if !SensorManager.getManager().isLocationAvailable() {
            self.navigationItem.prompt = "Enable location services!"
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        
        if let log = refillLog {
            quantityTextField.text = String(log.refillQnty)
            unitPriceTextField.text = String(log.unitPrice)
            refreshTotalPrice()
            refillType.text = log.type
            carPicker.selectRow(0, inComponent: 0, animated: false)
            //locationMapView.removeAnnotations()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchCars()
        super.viewWillAppear(animated)
    }
    
    
    
    @IBAction func saveButtonTap(sender: AnyObject) {
        if validateFields() {
            if let log = refillLog {
                updateRefillLog(log)
            } else {
                createRefillLog()
            }
            
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func updateRefillLog(log:RefillLog) {
        log.refillQnty = Double(quantityTextField.text!) ?? 0
        log.unitPrice = Double(unitPriceTextField.text!) ?? 0
        log.type = refillType.text
        
        let loc = locationMapView.userLocation.location
        
        log.lat = loc?.coordinate.latitude ?? 0
        log.lon = loc?.coordinate.longitude ?? 0
        log.altitude = loc?.altitude ?? 0
        
        log.odometer = 0 // TODO
        
        if let oldLog = refillLog {
            // should we refresh time?
            log.time = oldLog.time
        } else {
            log.time = NSDate()
        }
        
        // getting car
        let row = carPicker.selectedRowInComponent(0)
        
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        let car = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Car
        
        log.car = car
    }
    
    func createRefillLog() {
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("RefillLog",
            inManagedObjectContext: moc)
        
        let log = RefillLog(entity: entity!,
            insertIntoManagedObjectContext:moc)
        
        updateRefillLog(log)
        
        AppDelegate.sharedAppDelegate.saveContext()
    }
    
    func validateFields() -> Bool {
        var errorMsg = ""
        
        if quantityTextField.text == "" {
            errorMsg += "Quantity is empty!\n"
        }
        
        if unitPriceTextField.text == "" {
            errorMsg += "Unit price is empty!\n"
        }
        
        if refillType.text == "" {
            errorMsg += "Fuel type is empty!\n"
        }
        
        if errorMsg != "" {
            let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel,
                handler: nil)
            
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    // Determining total
    @IBAction func quantityChanged(sender: AnyObject) {
        refreshTotalPrice()
    }
    
    @IBAction func unitPriceChanged(sender: AnyObject) {
        refreshTotalPrice()
    }
    
    func refreshTotalPrice() {
        let quantityStr = quantityTextField.text
        let unitPriceStr = unitPriceTextField.text
        
        if quantityStr != "" && unitPriceStr != "" {
            let quantity = Double(quantityStr!) ?? 0
            let unitPrice = Double(unitPriceStr!) ?? 0
            
            totalLabel.text = "\(quantity * unitPrice)"
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
