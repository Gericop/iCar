//
//  RideTableViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 09/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import CoreData

class RideTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

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
        
        if SensorManager.getManager().isRecording() {
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.navigationItem.leftBarButtonItem?.enabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = true
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
    }
    
    func fetchRefills() {
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Ride")
        
        
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("RideCell", forIndexPath: indexPath)
        
        let ride = fetchedResultsController.objectAtIndexPath(indexPath) as! Ride
        
        cell.textLabel?.text = "\(ride.title!)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        
        if let endDate = ride.endDate {
            cell.detailTextLabel?.text = "\(dateFormatter.stringFromDate(ride.startDate!)) - \(dateFormatter.stringFromDate(endDate))"
        } else {
            cell.detailTextLabel?.text = "\(dateFormatter.stringFromDate(ride.startDate!)) - in progress..."
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
            let rideToDelete =
            fetchedResultsController.objectAtIndexPath(indexPath) as! Ride
            moc.deleteObject(rideToDelete)
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
        if segue.identifier == "RideDetails" {
            let ride = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! Ride
            let detailsVC = segue.destinationViewController as! RideDetailsViewController
            
            detailsVC.ride = ride
        } else if segue.identifier == "StopRide" {
            let detailsVC = segue.destinationViewController as! RideDetailsViewController
            
            detailsVC.ride = SensorManager.getManager().stopRide()
        }
    }


}
