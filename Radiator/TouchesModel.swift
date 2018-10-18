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
    var poistionView:UIView!
    
    init(view:UIView) {
        super.init()
        poistionView = view
    }
    
    func addTouchContainer(for touch:UITouch){
        
        let touchContainer = TouchContainer()
        touchContainer.setPosition(point: touch.location(in: poistionView))
        touches[touch] = touchContainer
        print("added",touches.count)
        
    }
    
    func updateTouchContainer(at touch:UITouch){
        
        if let shapeContainer = touches[touch]{
            print("updated",touches.count)
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
    
    override init() {
        super.init()
        shapeLayer = CAShapeLayer()
    }
    
    func setAngle(angle:CGFloat){
        self.angle = angle
    }
    
    func setPosition(point:CGPoint){
        shapeLayer.position = point
    }
    

    
}

struct Settings {
    static let dimension:CGFloat = 60.0
    static let duration:CFTimeInterval = 0.2
}
