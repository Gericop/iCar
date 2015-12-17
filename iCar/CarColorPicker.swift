//
//  CarColorPicker.swift
//  iCar
//
//  Created by Gergely Kőrössy on 17/12/15.
//  Copyright © 2015 Gergely Kőrössy. All rights reserved.
//

import UIKit

@IBDesignable
class CarColorPicker: UIView {
    
    let saturation:CGFloat = 0.2
    
    @IBInspectable
    var colorCount: CGFloat = 20
    
    private var selectedColorIndex = 0
    var selectedColor = UIColor.whiteColor()
    
    var colorWidth : CGFloat {
        return bounds.width / CGFloat(colorCount)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        for var i:CGFloat = 0; i<colorCount; i++ {
            if i == 0 {
                UIColor.redColor().setStroke()
                CGContextMoveToPoint(context, 0, bounds.height)
                CGContextAddLineToPoint(context, colorWidth, 0)
                CGContextStrokePath(context)
                
                UIColor.lightGrayColor().setStroke()
                CGContextStrokeRect(context, CGRect(x: 0, y: 0, width: colorWidth, height: bounds.height))
                //CGContextStrokePath(<#T##c: CGContext?##CGContext?#>)
            } else {
                let color = UIColor(hue: i*(1.0 / colorCount), saturation: saturation, brightness: 1.0, alpha: 1.0)
                color.setFill()
                
                CGContextFillRect(context, CGRect(x:colorWidth * i, y:0, width: colorWidth, height:bounds.height))
            }
            
            if Int(i) == selectedColorIndex {
                UIColor.blackColor().setStroke()
                CGContextSetLineWidth(context, 1.0)
                
                CGContextStrokeRect(context, CGRect(x:colorWidth * i, y:1, width: colorWidth - 1, height:bounds.height - 2))
            }
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        
        addGestureRecognizer(tapRecognizer)
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let tapPoint = gestureRecognizer.locationInView(self)
        selectedColorIndex = Int(tapPoint.x / colorWidth)
        selectedColor = UIColor(hue: CGFloat(selectedColorIndex) * (1.0 / colorCount), saturation: saturation, brightness: 1.0, alpha: 1.0)
        
        
        setNeedsDisplay()
    }

    func getSelectedColor() -> Int? {
        if selectedColorIndex == 0 {
            return nil
        }
        
        let components = CGColorGetComponents(selectedColor.CGColor)
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        return r << 16 + g << 8 + b
    }
    
    static func getColorFromInt(color:Int) -> UIColor {
        return UIColor(red: CGFloat(Double(color >> 16 & 0xff) / 255.0), green: CGFloat(Double(color >> 8 & 0xff) / 255.0), blue: CGFloat(Double(color & 0xff) / 255.0), alpha: 1.0)
    }
}
