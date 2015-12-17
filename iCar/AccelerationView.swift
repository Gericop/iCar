//
//  AccelerationView.swift
//  iCar
//
//  Created by Gergely Kőrössy on 17/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit

@IBDesignable
class AccelerationView: UIView {
    
    var accFrontal:[NSNumber] = []
    var accLateral:[NSNumber] = []
    
    let padding:CGFloat = 10
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 2.0)
        
        // axes
        UIColor.grayColor().setStroke()
        CGContextStrokeRect(context, CGRect(x:padding, y:padding + (bounds.height / 2 - 2*padding) / 2, width:bounds.width - 2*padding, height:0))
        CGContextStrokeRect(context, CGRect(x:bounds.width / 2, y:bounds.height / 2 + padding, width:0, height:bounds.height / 2 - 2*padding))
        
        // bounding rects
        UIColor.blackColor().setStroke()
        CGContextStrokeRect(context, CGRect(x:padding, y:padding, width:bounds.width - 2*padding, height:bounds.height / 2 - 2*padding))
        CGContextStrokeRect(context, CGRect(x:padding, y:bounds.height / 2 + padding, width:bounds.width - 2*padding, height:bounds.height / 2 - 2*padding))
        
    }
    
    func setRide(ride:Ride) {
        let points = ride.points?.allObjects as! [RidePoint]
        
        accFrontal.removeAll()
        accLateral.removeAll()
        
        for p in points {
            accFrontal.append(p.accFrontal!)
            accLateral.append(p.accLateral!)
        }
        
        setNeedsDisplay()
    }
}
