//
//  RefillEditorViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 08/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import CoreData

class RefillEditorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController!
    
    
    @IBOutlet weak var carPicker: UIPickerView!
    
    var refillLog : RefillLog?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //var datasource = UIPickerViewDataSource.
        
        carPicker.delegate = self
        carPicker.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchCars()
        super.viewWillAppear(animated)
    }
    
    @IBAction func saveButtonTap(sender: AnyObject) {
        if validateFields() {
            if let _ = refillLog {
                print("update")
            } else {
                print("create")
            }
            
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func validateFields() -> Bool {
        // TODO validate fields
        return true
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
