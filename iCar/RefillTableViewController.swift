//
//  RefillTableViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 08/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import CoreData

class RefillTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchRefills()
        
        tableView.reloadData()
        
        super.viewWillAppear(animated)
        
        SensorManager.getManager().requestPermission()
    }
    
    func fetchRefills() {
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"RefillLog")
        
        
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "car.enabled == 1")
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        fetchedResultsController.delegate = self
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as
        NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RefillLogCell", forIndexPath: indexPath)
        
        let refill = fetchedResultsController.objectAtIndexPath(indexPath) as! RefillLog
        
        cell.textLabel?.text = "\(refill.refillQnty!) liter"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        cell.detailTextLabel?.text =
            dateFormatter.stringFromDate(refill.time!)
        
        // coloring from car
        if let rowColor = (refill.car as! Car).rowColor {
            cell.backgroundColor = CarColorPicker.getColorFromInt(Int(rowColor))
        } else {
            cell.backgroundColor = UIColor.clearColor()
        }

        return cell
    }
    
    // NSFetchedResultsControllerDelegate implementation
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject
        anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType
        type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!],
                    withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                /*case .Update:
                let cell = tableView.cellForRowAtIndexPath(indexPath!)!
                configureCell(cell, atIndexPath: indexPath!)*/
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!],
                    withRowAnimation: .Fade)
            default:
                break
            }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let moc = AppDelegate.sharedAppDelegate.managedObjectContext
            let refillToDelete =
            fetchedResultsController.objectAtIndexPath(indexPath) as! RefillLog
            moc.deleteObject(refillToDelete)
            // we will save it in AppDelegate.applicationDidEnterBackground()
            // AppDelegate.sharedAppDelegate.saveContext()
        }
    }

    @IBAction func searchButtonTap(sender: AnyObject) {
        SensorManager.getManager().requestPermission()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "AddRefillLog" && segue.identifier != "SearchLog" {
            let log = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! RefillLog
            let detailsVC = segue.destinationViewController as! RefillDetailsViewController
            
            detailsVC.refillLog = log
        }
    }
    

}
