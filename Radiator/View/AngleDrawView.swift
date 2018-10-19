//
//  AngleDrawView.swift
//  Radiator
//
//  Created by Joss Manger on 10/17/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class AngleDrawView: UIView {
    
    let dimension:CGFloat = Settings.dimension
    let duration:CFTimeInterval = Settings.duration
    
    var angle:CGFloat = 0.0
    
    private var touchSize:CGSize!
    
    var touches:[UITouch]=[]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(box: CGRect) {
        
        self.init(frame: box)
        touchSize = CGSize(width: dimension, height: dimension)
        
    }
    
    func setupShape(shapeContainer:TouchContainer){
        
            let (touchShape,label) = shapeContainer.getShapes()
            touchShape.frame = CGRect(origin: .zero, size: touchSize)
            touchShape.path = CGPath(rect: touchShape.frame, transform: nil)
            touchShape.fillColor = UIColor.clear.cgColor
            touchShape.lineWidth = 1.0
            touchShape.actions = ["position":NSNull()]
            touchShape.opacity = 0.0
            touchShape.strokeColor = UIColor.red.cgColor
            self.layer.addSublayer(touchShape)
        
            self.layer.addSublayer(label)
        
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
        
        
        //touchShapes[touch] = touchShape
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getClearArea()->CGRect{
        
        let path = CGMutablePath()

        for shape in touches{
            let location = shape.location(in: self)
            
            path.addLine(to: location)
        }
        
        
        
        return path.boundingBox.offsetBy(dx: dimension, dy: dimension)
        
    }
    
  
    var data:TouchesContainer?
    
    func update(snapshot:TouchesContainer){
        
        touches = Array(snapshot.touches.keys)
        data = snapshot
        setNeedsDisplay()
        //update location of existing touches
        //angle is from first touch

//        let point = touch.location(in: self)
//        let touchmid = CGPoint(x: point.x - (dimension/2), y: point.y - (dimension/2))
//
//        touchShapes[touch]?.frame.origin = touchmid
//
//        self.angle = angle
        //rect
        //let rect = getClearArea()
        //print(rect)
        
        
    }
    
    func clear(shapeContainer:TouchContainer){
        //let clearArea = getClearArea()
        
        shapeContainer.getShapes().1.removeFromSuperlayer()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock({            
            print("fadeout complete")
            
            shapeContainer.getShapes().0.removeFromSuperlayer()
            self.setNeedsDisplay()
        })
        CATransaction.setDisableActions(true)
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1.0
        anim.toValue = 0.0
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        
        shapeContainer.getShapes().0.add(anim, forKey: "opacity")
        

        
        CATransaction.commit()
        
        
        
        
        
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //print(touchShapes.count)
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
        if let data = data{
            
        
        for (key,container) in data.touches{
            
            context?.beginPath()
            context?.move(to: mid)
            context?.addLine(to: key.location(in: self))
            context?.strokePath()
            
            let prevAngle = (container.getPrev() != nil) ? container.getPrev()!.getAngle() : CGFloat(0.0)
            let startAngle = -CGFloat(degToRad(90.0)) - prevAngle
            
            let endangle =  -container.getAngle() - CGFloat(degToRad(90.0))
            context?.beginPath()
            context?.addArc(center: mid, radius: dimension/2 + CGFloat(10 * container.getIndex()), startAngle: startAngle, endAngle: endangle, clockwise: false)
            context?.strokePath()
            
            
        }

        }


        
        
    }
 

}
