//
//  RefillDetailsViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 09/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit
import MapKit

class RefillDetailsViewController: UIViewController {
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var unitPriceField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var odometerField: UITextField!
    
    @IBOutlet weak var carField: UITextField!
    
    @IBOutlet weak var locationMapView: MKMapView!
    var refillLog : RefillLog?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let log = refillLog {
            quantityField.text = String(log.refillQnty!)
            unitPriceField.text = String(log.unitPrice!)
            typeField.text = log.type
            odometerField.text = String(log.odometer!) + "km"
            
            refreshTotalPrice()
            
            let car = log.car as! Car
            carField.text = "\(car.name!) [\(car.licensePlate!)]"
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .MediumStyle
            navigationItem.prompt = dateFormatter.stringFromDate(log.time!)
            
            // setting map
            let mapAnnotation = MapPointAnnotation()
            let coords = CLLocationCoordinate2DMake(CLLocationDegrees(log.lat!), CLLocationDegrees(log.lon!))
            mapAnnotation.setCoordinate(coords)
            locationMapView.addAnnotation(mapAnnotation)
            locationMapView.centerCoordinate = coords
        }
    }

    func refreshTotalPrice() {
        let quantityStr = quantityField.text
        let unitPriceStr = unitPriceField.text
        
        if quantityStr != "" && unitPriceStr != "" {
            let quantity = Double(quantityStr!) ?? 0
            let unitPrice = Double(unitPriceStr!) ?? 0
            
            totalLabel.text = "\(quantity * unitPrice)"
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if segue.identifier != "AddRefillLog" {
            let detailsVC = segue.destinationViewController as! RefillEditorViewController
            
            detailsVC.refillLog = refillLog
        //}
    }

}
