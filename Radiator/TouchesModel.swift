//
//  TouchesModel.swift
//  Radiator
//
//  Created by Joss Manger on 10/18/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class TouchesContainer : NSObject{
    
    var touches:[UITouch:TouchContainer] = [:]
    var mostRecentTouch:UITouch?
    var poistionView:UIView!
    
    init(view:UIView) {
        super.init()
        poistionView = view
    }
    
    func addTouchContainer(for touch:UITouch){
        
        let touchContainer = TouchContainer()
        
        if let mostRecentTouch = mostRecentTouch{
            let last = touches[mostRecentTouch]
            touchContainer.setPrevious(previous: last)
            last?.updateNext(next: touchContainer)
        }
        
        mostRecentTouch = touch
        
        touchContainer.setPosition(point: touch.location(in: poistionView))
        touches[touch] = touchContainer
        print("added",touches.count)
        
    }
    
    func updateTouchContainer(at touch:UITouch){
        
        if let shapeContainer = touches[touch]{
            //print("updated",touches.count)
            shapeContainer.setPosition(point: touch.location(in: poistionView))
        }
        
    }
    
    func removeTouchContainer(for touch:UITouch){
        touches.removeValue(forKey: touch)
        print("removed",touches.count)
    }
    
}


class TouchContainer : NSObject {
    
    private var shapeLayer:CAShapeLayer!
    
    private var angle:CGFloat = 0.0
    
    private weak var next:TouchContainer?
    private weak var prev:TouchContainer?
    
    override init() {
        super.init()
        shapeLayer = CAShapeLayer()
        
    }
    
    func setPrevious(previous:TouchContainer?){
        self.prev = previous
    }
    
    func updateNext(next: TouchContainer){
        self.next = next
        print("self: \(String(format: "%p", unsafeBitCast(self, to: Int.self))) has next \(String(format: "%p", unsafeBitCast(next, to: Int.self))) and prev \(String(format: "%p", unsafeBitCast(prev, to: Int.self)))")
    }
    
    func setAngle(angle:CGFloat){
        self.angle = angle
    }
    
    func setPosition(point:CGPoint){
        shapeLayer.position = point
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
