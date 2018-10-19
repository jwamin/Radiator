//
//  TouchesModel.swift
//  Radiator
//
//  Created by Joss Manger on 10/18/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

protocol TouchModelDelegate {
    func addedShape(_ hashedShape:TouchContainer)
    func updatedShape(_ hashedShape:TouchContainer)
    func removedShape(_ hashedShape:TouchContainer)
}

class TouchesContainer : NSObject{
    
    var touches:[UITouch:TouchContainer] = [:]
    var mostRecentTouch:UITouch?
    var poistionView:UIView!
    
    var delegate:TouchModelDelegate?
    
    init(view:UIView) {
        super.init()
        poistionView = view
    }
    
    func calculateAngle(for touch:UITouch)->CGFloat{
        let touchPoint = touch.location(in: poistionView)
        let mid = CGPoint(x: poistionView.bounds.midX, y: poistionView.bounds.midY)
        let dx = -(touchPoint.x - mid.x)
        let dy = -(touchPoint.y - mid.y)
        let angle = atan2(dx, dy)
        return CGFloat(angle)
    }
    
    func positionTextLabel(for container:TouchContainer){
        let radius = Settings.dimension + CGFloat(10 * container.getIndex())
        let mid = CGPoint(x: poistionView.bounds.midX, y: poistionView.bounds.midY)
        let positionAngle = container.getAngle()/2
        let x = radius * cos(positionAngle) + mid.x
        let y = radius * sin(positionAngle) + mid.y
        let point = CGPoint(x: x, y: y)
        container.positionandSetLabel(position: point)
    }
    
    func addTouchContainer(for touch:UITouch){
        
        let touchContainer = TouchContainer(index: touches.count)
        
        if let mostRecentTouch = mostRecentTouch{
            let last = touches[mostRecentTouch]
            touchContainer.setPrevious(previous: last)
            touchContainer.updateAngle(angle: calculateAngle(for: touch))
            last?.updateNext(next: touchContainer)
        }
        
        mostRecentTouch = touch
        
        touchContainer.setPosition(point: touch.location(in: poistionView))
        positionTextLabel(for: touchContainer)
        touches[touch] = touchContainer
        print("added",touches.count)
        delegate?.addedShape(touchContainer)
    }
    
    func updateTouchContainer(at touch:UITouch){
        
        if let shapeContainer = touches[touch]{
            //print("updated",touches.count)
            shapeContainer.setPosition(point: touch.location(in: poistionView))
            shapeContainer.updateAngle(angle: calculateAngle(for: touch))
            positionTextLabel(for: shapeContainer)
            delegate?.updatedShape(shapeContainer)
        }
        
    }
    
    func removeTouchContainer(for touch:UITouch){
        
        if let shapeContainer = touches[touch]{
            delegate?.removedShape(shapeContainer)
            touches.removeValue(forKey: touch)
            print("removed",touches.count)
        }
        
    }
    
}


class TouchContainer : NSObject {
    
    private var shapeLayer:CAShapeLayer!
    private var textLayer:CATextLayer!
    private var angle:CGFloat = 0.0
    
    private let index:Int!
    
    private weak var next:TouchContainer?
    private weak var prev:TouchContainer?
    
    init(index:Int) {
        self.index = index
        super.init()
        shapeLayer = CAShapeLayer()
        textLayer = CATextLayer()
        
        textLayer.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 20))
        textLayer.actions = ["position":NSNull()]
        textLayer.string = "test"
        textLayer.fontSize = 20
        textLayer.foregroundColor = UIColor.red.cgColor
        
    }
    
    func getIndex()->Int{
        
        return self.index
        
    }
    
    func getPrev()->TouchContainer?{
        
        return prev
        
    }
    
    func positionandSetLabel(position:CGPoint){
   
        textLayer.string = DrawViewController.angleString(angle: angle, radians: false)
        textLayer.backgroundColor = UIColor.red.cgColor
        textLayer.position = position
    }
    
    func getAngle()->CGFloat{
        return angle
    }
    
    func setPrevious(previous:TouchContainer?){
        self.prev = previous
    }
    
    func updateNext(next: TouchContainer){
        self.next = next
        //print("self: \(String(format: "%p", unsafeBitCast(self, to: Int.self))) has next \(String(format: "%p", unsafeBitCast(next, to: Int.self))) and prev \(String(format: "%p", unsafeBitCast(prev, to: Int.self)))")
    }
    
    func updateAngle(angle:CGFloat){
        
           self.angle = angle
        
    }
    
    func setPosition(point:CGPoint){
        shapeLayer.position = point
        
    }
    
    func getShapes()->(CAShapeLayer,CATextLayer){
        return (shapeLayer,textLayer)
    }
    
    deinit {
        print("has next \(String(format: "%p", unsafeBitCast(next, to: Int.self))) and prev \(String(format: "%p", unsafeBitCast(prev, to: Int.self)))")
        print("deallocating \(String(format: "%p", unsafeBitCast(self, to: Int.self)))")
    }
    
}

struct Settings {
    static let dimension:CGFloat = 60.0
    static let duration:CFTimeInterval = 0.2
}
