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
   
    var angle:CGFloat = 0.0
    let dimension:CGFloat = 60.0
    var touchShapes:[UITouch:CAShapeLayer] = [:]
    let duration:CFTimeInterval = 0.2
    
    var size:CGSize!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(box: CGRect) {
        self.init(frame: box)
        size = CGSize(width: dimension, height: dimension)
        
    }
    
    func setupShape(touch:UITouch){
        
            let touchShape = CAShapeLayer()
            let point = touch.location(in: self)
            touchShape.frame = CGRect(origin: .zero, size: size)
            touchShape.path = CGPath(rect: touchShape.frame, transform: nil)
            touchShape.fillColor = UIColor.clear.cgColor
            touchShape.lineWidth = 1.0
            touchShape.actions = ["position":NSNull()]
            touchShape.opacity = 0.0
            touchShape.strokeColor = UIColor.red.cgColor
            let touchmid = CGPoint(x: point.x - (dimension/2), y: point.y - (dimension/2))
            touchShape.frame.origin = touchmid
            self.layer.addSublayer(touchShape)
        
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setDisableActions(true)
            
            let anim = CABasicAnimation(keyPath: "opacity")
            anim.fromValue = 0.0
            anim.toValue = 1.0
            anim.fillMode = .forwards
            anim.isRemovedOnCompletion = false
            
            let trans = CABasicAnimation(keyPath: "transform")
            trans.fromValue = CATransform3DConcat(CATransform3DScale(CATransform3DIdentity, 10.0, 10.0, 10.0), CATransform3DRotate(CATransform3DIdentity, 1.570796, 0.0, 0.0, 1.0))
            trans.toValue = CATransform3DIdentity
            trans.fillMode = .forwards
            trans.isRemovedOnCompletion = false
            
            let group = CAAnimationGroup()
            group.duration = duration
            group.fillMode = .forwards
            group.isRemovedOnCompletion = false
            group.animations = [anim,trans]
            
            touchShape.add(group, forKey: "touchZoom")
            CATransaction.commit()
        
        
        touchShapes[touch] = touchShape
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getClearArea()->CGRect{
        
        let path = CGMutablePath()

        for shape in touchShapes{
            let location = shape.key.location(in: self)
            
            path.addLine(to: location)
        }
        
        
        
        return path.boundingBox.offsetBy(dx: dimension, dy: dimension)
        
    }
    
    func clear(touch:UITouch){
        let clearArea = getClearArea()
        
        if let touchShape = touchShapes[touch]{
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setDisableActions(true)
            let anim = CABasicAnimation(keyPath: "opacity")
            anim.fromValue = 1.0
            anim.toValue = 0.0
            anim.fillMode = .forwards
            anim.isRemovedOnCompletion = false
            
            touchShape.add(anim, forKey: "opacity")
            CATransaction.setCompletionBlock {
                touchShape.removeFromSuperlayer()
                self.touchShapes.removeValue(forKey: touch)
            }
            CATransaction.commit()
            
            
            
            print(touchShapes.count)
            
            //print("clear",clearArea)
            self.setNeedsDisplay(clearArea)
            
        }
        

    }

    
    func update(touch:UITouch,angle:CGFloat){
        
        //update location of existing touches
        //angle is from first touch
//        for (index,touch) in touches.enumerated(){
//
//        }
        let point = touch.location(in: self)
        let touchmid = CGPoint(x: point.x - (dimension/2), y: point.y - (dimension/2))
        
        touchShapes[touch]?.frame.origin = touchmid
        
        self.angle = angle
        //rect
        let rect = getClearArea()
        //print(rect)
        self.setNeedsDisplay()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print(touchShapes.count)
        //print("drawing",touches.count,rect)
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        context?.setFillColor(UIColor.clear.cgColor)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(1.0)
        context?.setLineJoin(.bevel)
        let mid = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        //Inner Circle
        context?.beginPath()
        context?.setLineWidth(1.0)
        let siedDIm = CGFloat(10.0)
        let positionAdjust = CGPoint(x: mid.x - siedDIm/2, y:  mid.y - siedDIm/2)
        context?.strokeEllipse(in: CGRect(origin: positionAdjust, size: CGSize(width: siedDIm, height: siedDIm)))
        context?.strokePath()
        
        //Wider Cricle
        context?.beginPath()
        context?.setLineWidth(2.0)
        let siedDIm2 = CGFloat(250.0)
        let posAdjust = CGPoint(x: mid.x - siedDIm2/2, y:  mid.y - siedDIm2/2)
        context?.strokeEllipse(in: CGRect(origin: posAdjust, size: CGSize(width: siedDIm2, height: siedDIm2)))
        context?.strokePath()
        
        
        context?.setLineWidth(1.0)
        
        if touchShapes.count != 0{
            context?.beginPath()
            context?.move(to: mid)
            context?.addLine(to: touchShapes.first!.key.location(in: self))
            context?.strokePath()
        }

        
        let startAngle = -CGFloat(degToRad(90.0))
        let endangle =  -angle - CGFloat(degToRad(90.0))
        context?.beginPath()
        context?.addArc(center: mid, radius: dimension/2, startAngle: startAngle, endAngle: endangle, clockwise: false)
        context?.strokePath()
        
        for shape in touchShapes {
            
            //update touch areas
            
            let touch = shape.key.location(in: self)

            let touchmid = CGPoint(x: touch.x - (dimension/2), y: touch.y - (dimension/2))
            shape.value.frame.origin = touchmid
            
            
            

            
        }
        
        
    }
 

}
