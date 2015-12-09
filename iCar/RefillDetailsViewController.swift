//
//  RefillDetailsViewController.swift
//  iCar
//
//  Created by Gergely Kőrössy on 09/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit

class RefillDetailsViewController: UIViewController {
    
    var refillLog : RefillLog?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
