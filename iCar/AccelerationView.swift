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
    
    var accFrontal:[Double] = []
    var accLateral:[Double] = []
    
    let padding:CGFloat = 20
    
    let zero = "0"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let w = bounds.width - 2*padding
        let h = bounds.height / 2 - 2*padding
        
        let context = UIGraphicsGetCurrentContext()
        
        drawAxes(context!, w: w, h: h)
        
        // data
        UIColor.redColor().setStroke()
        CGContextSetLineWidth(context, 1.0)
        
        // data - frontal
        if accFrontal.count > 1 {
            if let max = accFrontal.maxElement(), let min = accFrontal.minElement() {
                
                let count = accFrontal.count
                let stepX = w / CGFloat(count-1)
                let stepY = (h / 2 - 2) / CGFloat((abs(max) < abs(min)) ? abs(min) : abs(max))
                
                for var i = 0; i < count; i++ {
                    let y = padding + h / 2 - CGFloat(accFrontal[i]) * stepY
                    if(i == 0) {
                        CGContextMoveToPoint(context, padding, y)
                    } else {
                        CGContextAddLineToPoint(context, padding + CGFloat(i) * stepX, y);
                    }
                }
            }
        }
        
        // data - lateral
        if accLateral.count > 1 {
            if let max = accLateral.maxElement(), let min = accLateral.minElement() {
                
                let count = accLateral.count
                let stepY = h / CGFloat(count-1)
                let stepX = (w / 2 - 2) / CGFloat((abs(max) < abs(min)) ? abs(min) : abs(max))
                
                for var i = 0; i < count; i++ {
                    let x = padding + w / 2 + CGFloat(accLateral[i]) * stepX
                    if(i == 0) {
                        CGContextMoveToPoint(context, x, 3*padding + h*2)
                    } else {
                        CGContextAddLineToPoint(context, x, 3*padding + h*2 - CGFloat(i) * stepY);
                    }
                }
            }
        }
        
        CGContextStrokePath(context)
    }
    
    func drawAxes(context:CGContext, w:CGFloat, h:CGFloat) {
        CGContextSetLineWidth(context, 1.0)
        
        // axes
        UIColor.grayColor().setStroke()
        CGContextStrokeRect(context, CGRect(x:padding, y:padding + (bounds.height / 2 - 2*padding) / 2, width: w, height:0))
        CGContextStrokeRect(context, CGRect(x:bounds.width / 2, y:bounds.height / 2 + padding, width:0, height: h))
        
        // bounding rects
        CGContextStrokeRect(context, CGRect(x:padding, y:padding, width: w, height: h))
        CGContextStrokeRect(context, CGRect(x:padding, y:bounds.height / 2 + padding, width: w, height: h))
        
        // arrows
        UIColor.blackColor().setStroke()
        CGContextSetLineWidth(context, 2.0)
        
        // arrows - frontal
        
        CGContextMoveToPoint(context, padding, padding + h)
        CGContextAddLineToPoint(context, padding-5, padding + h - 5)
        CGContextMoveToPoint(context, padding, padding + h)
        CGContextAddLineToPoint(context, padding+5, padding + h - 5)
        
        CGContextMoveToPoint(context, padding, padding + h)
        CGContextAddLineToPoint(context, padding, padding)
        CGContextAddLineToPoint(context, padding-5, padding+5)
        CGContextMoveToPoint(context, padding, padding)
        CGContextAddLineToPoint(context, padding+5, padding+5)
        
        CGContextMoveToPoint(context, padding, padding + h / 2)
        CGContextAddLineToPoint(context, padding + w, padding + h / 2)
        CGContextAddLineToPoint(context, padding + w - 5, padding + h / 2 - 5)
        CGContextMoveToPoint(context, padding + w, padding + h / 2)
        CGContextAddLineToPoint(context, padding + w - 5, padding + h / 2 + 5)
        
        // arrows - lateral
        CGContextMoveToPoint(context, padding, bounds.height - padding)
        CGContextAddLineToPoint(context, padding + 5, bounds.height - padding - 5)
        CGContextMoveToPoint(context, padding, bounds.height - padding)
        CGContextAddLineToPoint(context, padding + 5, bounds.height - padding + 5)
        
        CGContextMoveToPoint(context, padding, bounds.height - padding)
        CGContextAddLineToPoint(context, padding + w, bounds.height - padding)
        
        CGContextAddLineToPoint(context, padding + w - 5, bounds.height - padding - 5)
        CGContextMoveToPoint(context, padding + w, bounds.height - padding)
        CGContextAddLineToPoint(context, padding + w - 5, bounds.height - padding + 5)
        
        CGContextMoveToPoint(context, padding + w / 2, bounds.height - padding)
        CGContextAddLineToPoint(context, padding + w / 2, bounds.height - padding - h)
        CGContextAddLineToPoint(context, padding + w / 2 - 5, bounds.height - padding - h + 5)
        CGContextMoveToPoint(context, padding + w / 2, bounds.height - padding - h)
        CGContextAddLineToPoint(context, padding + w / 2 + 5, bounds.height - padding - h + 5)
        
        // drawing arrows
        CGContextStrokePath(context)
    }
    
    func setRide(ride:Ride) {
        let points = ride.points?.allObjects as! [RidePoint]
        
        accFrontal.removeAll()
        accLateral.removeAll()
        
        for p in points {
            accFrontal.append(Double(p.accFrontal!))
            accLateral.append(Double(p.accLateral!))
        }
        
        setNeedsDisplay()
    }
    
}
