//
//  ViewController.swift
//  Radiator
//
//  Created by Joss Manger on 10/16/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController,TouchModelDelegate {

    
    
    var drawingView:AngleDrawView!
    var touchModel:TouchesContainer!
    
    var radians = true {
        didSet{
            print("radians set: \(radians)")
            updateAngle()
        }
    }
    
    var angle:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print90DegreesInRadians()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        drawingView = AngleDrawView(box:self.view.frame)
        drawingView.isMultipleTouchEnabled = true
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.isMultipleTouchEnabled = true
        self.view.addSubview(drawingView)
        setupConstraints()
        
        touchModel = TouchesContainer(view: drawingView)
        touchModel.delegate = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        drawingView.setNeedsDisplay()
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint(item: drawingView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: drawingView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: drawingView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: drawingView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
        
        
    }
    
    @objc func handleChange(_ recognizer:UIGestureRecognizer){
        print("tap")
        radians = !radians
    }
    
    
    
    
    
    func print90DegreesInRadians(){
        var degrees = 90.0
        
        let radians = degToRad(degrees)
        
        print("radians: \(radians)")
        print("pointerRadians: \(pointerToRadians(&degrees))")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("began \(touches.count)")
        for touch in touches{
            //drawingView.setupShape(touch: touch)
            touchModel.addTouchContainer(for: touch)
            updateAngle()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("movedd \(touches.count)")
        //handle first point position, set label
        updateAngle()
        
        for touch in touches{
            //drawingView.update(touch: touch,angle:angle)
            touchModel.updateTouchContainer(at: touch)
            //            if let coalesced = event?.coalescedTouches(for: touch){
            //                for touch in coalesced{
            //                    pointouches.append(touch.location(in: self.drawingView))
            //                }
            //            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            //drawingView.clear(touch: touch)
            touchModel.removeTouchContainer(for: touch)
        }
        
    }
    
    func calculateAngle(touch:CGPoint) -> CGFloat{
        let mid = CGPoint(x: self.drawingView.bounds.midX, y: self.drawingView.bounds.midY)
        let dx = -(touch.x - mid.x)
        let dy = -(touch.y - mid.y)
        let angle = atan2(dx, dy)
        return CGFloat(angle)
    }
    
    func setLabel(position:CGPoint?,angle:CGFloat){
        
        // adjust atan2 auotpu for 360degree / 3.14*2 format
        let angleString = (angle<0) ? -angle : .pi - angle + .pi
        
        //if first touch coordinate is available, concat to string
        let labelString = (position != nil) ? "x:\(round(position!.x)) y:\(round(position!.y)) \n" : ""
        
        //Fix value for desired unit
        let convertedAngle =  (radians) ? angleString : CGFloat(radToDegrees(Double(angleString)))
        
        //Fix suffix for desired unit, format for attributed display
        let suffixString = (radians) ? NSAttributedString(string: "c", attributes: [.baselineOffset:10,.font:UIFont.systemFont(ofSize: 10)]) : NSAttributedString(string: "°");
        
        //concat attributed strings
        let attributed = NSMutableAttributedString(string: "\(labelString) \(String(format: "%.3f", convertedAngle))")
        attributed.append(suffixString)
        
        //set label on parent
        (parent as! ParentViewController).label.attributedText = attributed
    }
    
    
    func updateAngle(){
        if let firstTouchShape = touchModel.touches.first{
            let firstTouchLocation = firstTouchShape.key.location(in: drawingView)
            angle = calculateAngle(touch: firstTouchLocation)
            setLabel(position: firstTouchLocation, angle: angle)
        } else {
            setLabel(position: nil, angle: drawingView.angle)
        }
    }
    
    //TouchModel Delegate methods
    
    func addedShape(_ hashedShape: TouchContainer) {
        drawingView.setupShape(shapeContainer: hashedShape)
        drawingView.update(snapshot: touchModel)
    }
    
    func updatedShape(_ hashedShape: TouchContainer) {
        drawingView.update(snapshot: touchModel)
    }
    
    func removedShape(_ hashedShape: TouchContainer) {
        drawingView.clear(shapeContainer: hashedShape)
        drawingView.update(snapshot: touchModel)
    }
    
}

