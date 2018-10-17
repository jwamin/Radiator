//
//  AngleDrawView.swift
//  Radiator
//
//  Created by Joss Manger on 10/17/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class AngleDrawView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
  */
    var touches:[CGPoint] = []
    var angle:CGFloat = 0.0
    let dimension:CGFloat = 60.0
    
    private func getClearArea()->CGRect{
        
        let path = CGMutablePath()

            path.addLines(between: touches)
        
        return path.boundingBox.offsetBy(dx: dimension, dy: dimension)
        
    }
    
    func clear(){
        let clearArea = getClearArea()
        self.touches = []
        print("clear",clearArea)
        self.setNeedsDisplay(clearArea)
    }
    
    func update(touches:[CGPoint],angle:CGFloat){
        
        self.touches = touches
        self.angle = angle
        //rect
        let rect = getClearArea()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //print("drawing",touches.count,rect)
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        context?.setFillColor(UIColor.clear.cgColor)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(1.0)
        context?.setLineJoin(.bevel)
        let mid = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        var rect = CGRect(origin: mid, size: CGSize(width: dimension, height: dimension))
        
        context?.fillEllipse(in: rect)
        
        
        for touch in touches {
            
            let touchmid = CGPoint(x: touch.x - (dimension/2), y: touch.y - (dimension/2))
            
            context?.beginPath()
            context?.move(to: mid)
            context?.addLine(to: touch)
            context?.strokePath()
            
            rect.origin = touchmid
            context?.stroke(rect)
            
            context?.beginPath()
            
            let startAngle = -CGFloat(degToRad(90.0))
            let endangle =  -angle - CGFloat(degToRad(90.0))
            context?.addArc(center: mid, radius: dimension/2, startAngle: startAngle, endAngle: endangle, clockwise: false)
            context?.strokePath()
            
        }
        
        
    }
 

}
