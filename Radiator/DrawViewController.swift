//
//  ViewController.swift
//  Radiator
//
//  Created by Joss Manger on 10/16/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController,TouchModelDelegate {

    //Instance Variables
    
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
    
    //Layout methods
    
    func setupConstraints(){
        
        NSLayoutConstraint(item: drawingView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: drawingView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: drawingView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: drawingView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
        
    }
    
    //Actions
    
    @objc func handleChange(_ recognizer:UIGestureRecognizer){
        print("tap")
        radians = !radians
    }
    
    // Responder Methods
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        drawingView.setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{

            touchModel.addTouchContainer(for: touch)
            updateAngle()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        //handle first point position, set label
        updateAngle()
        
        for touch in touches{

            touchModel.updateTouchContainer(at: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            //drawingView.clear(touch: touch)
            touchModel.removeTouchContainer(for: touch)
        }
        
    }
    
    //UI Updates
    
    public static func angleString(angle:CGFloat,radians:Bool)->NSAttributedString{
        // adjust atan2 auotpu for 360degree / 3.14*2 format
        let angleString = (angle<0) ? -angle : .pi - angle + .pi
        //Fix value for desired unit
        let convertedAngle =  (radians) ? angleString : CGFloat(radToDegrees(Double(angleString)))
        
        //Fix suffix for desired unit, format for attributed display
        let suffixString = (radians) ? NSAttributedString(string: "c", attributes: [.baselineOffset:10,.font:UIFont.systemFont(ofSize: 10)]) : NSAttributedString(string: "°");
        
        let mutable = NSMutableAttributedString(string: "\(String(format: "%.3f", convertedAngle))")
        mutable.append(suffixString)
        
        return mutable
        
    }
    
    func setLabel(position:CGPoint?,angle:CGFloat){
        
        
        
        //if first touch coordinate is available, concat to string
        let labelString = (position != nil) ? "x:\(round(position!.x)) y:\(round(position!.y)) \n" : ""
        
        let attrstring = DrawViewController.angleString(angle: angle, radians: radians)
        
        //set label on parent
        (parent as! ParentViewController).label.attributedText = attrstring
    }
    
    
    func updateAngle(){
        if let firstTouchShape = touchModel.touches.first{
            let firstTouchLocation = firstTouchShape.key.location(in: drawingView)
            angle = firstTouchShape.value.getAngle()
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
    
    //Diagnostic

    func print90DegreesInRadians(){
        var degrees = 90.0
        
        let radians = degToRad(degrees)
        
        print("radians: \(radians)")
        print("pointerRadians: \(pointerToRadians(&degrees))")
    }
    
}

