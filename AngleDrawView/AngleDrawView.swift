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
    let touchShape = CAShapeLayer()
    let duration:CFTimeInterval = 0.2
    
    var size:CGSize!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(box: CGRect) {
        self.init(frame: box)
        size = CGSize(width: dimension, height: dimension)
        setupShape()
    }
    
    func setupShape(){
        
        
            touchShape.frame = CGRect(origin: .zero, size: size)
            touchShape.path = CGPath(rect: touchShape.frame, transform: nil)
            touchShape.fillColor = UIColor.clear.cgColor
            touchShape.lineWidth = 1.0
            touchShape.actions = ["position":NSNull()]
            touchShape.opacity = 0.0
            touchShape.strokeColor = UIColor.red.cgColor
            self.layer.addSublayer(touchShape)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getClearArea()->CGRect{
        
        let path = CGMutablePath()

            path.addLines(between: touches)
        
        return path.boundingBox.offsetBy(dx: dimension, dy: dimension)
        
    }
    
    func clear(){
        let clearArea = getClearArea()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setDisableActions(true)
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1.0
        anim.toValue = 0.0
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        touchShape.add(anim, forKey: "opacity")
        CATransaction.commit()
        
        self.touches = []
        print("clear",clearArea)
        self.setNeedsDisplay(clearArea)
        
    }
    
    func update(touches:[CGPoint],angle:CGFloat){
        
        if (self.touches.count == 0){
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setDisableActions(true)
            let anim = CABasicAnimation(keyPath: "opacity")
            anim.fromValue = 0.0
            anim.toValue = 1.0
            anim.fillMode = .forwards
            anim.isRemovedOnCompletion = false
            touchShape.add(anim, forKey: "opacity")
            CATransaction.commit()
        }
        
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
        
        
        context?.fillEllipse(in: rect)
        
        
        for touch in touches {
            
            let touchmid = CGPoint(x: touch.x - (dimension/2), y: touch.y - (dimension/2))
            
            context?.beginPath()
            context?.move(to: mid)
            context?.addLine(to: touch)
            context?.strokePath()
            
            touchShape.frame.origin = touchmid
            print(touchShape.frame.origin)
            
            context?.beginPath()
            
            let startAngle = -CGFloat(degToRad(90.0))
            let endangle =  -angle - CGFloat(degToRad(90.0))
            context?.addArc(center: mid, radius: dimension/2, startAngle: startAngle, endAngle: endangle, clockwise: false)
            context?.strokePath()
            
        }
        
        
    }
 

}
