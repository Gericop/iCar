//
//  CarTableViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 07/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import CoreData

class CarTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var cars = [Car]()
    var fetchedResultsController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCars()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchCars()
        
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    func fetchCars() {
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Car")
        /*do {
        if let notebooks = try moc.executeFetchRequest(fetchRequest) as? [Notebook] {
        self.notebooks = notebooks
        }
        } catch {
        print("Could not fetch")
        }*/
        
        
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CarCell", forIndexPath: indexPath) as! CarTableViewCell

        let car = fetchedResultsController.objectAtIndexPath(indexPath) as! Car
        
        cell.titleLabel.text = car.name
        cell.licensePlateLabel.text = car.licensePlate
        cell.enablerSwitch.on = car.enabled != 0
        cell.car = car

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
            let carToDelete =
            fetchedResultsController.objectAtIndexPath(indexPath) as! Car
            moc.deleteObject(carToDelete)
            // we will save it in AppDelegate.applicationDidEnterBackground()
            // AppDelegate.sharedAppDelegate.saveContext()
        }
        /*if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "AddCar" {
            let car = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as! Car
            let carVC = segue.destinationViewController as! CarDetailsViewController
        
            carVC.car = car
        }
    }


}
