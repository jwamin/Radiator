//
//  ViewController.swift
//  Radiator
//
//  Created by Joss Manger on 10/16/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var drawingView:AngleDrawView!
    var label:UILabel!
    
    var radians = true {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print90DegreesInRadians()
        
        drawingView = AngleDrawView(frame:self.view.bounds)
        
        self.view.addSubview(drawingView)
        
        setupLabel()
        
    }
    
    @objc func handleChange(_ recognizer:UIGestureRecognizer){
        print("tap")
        radians = !radians
    }
    
    func setupLabel(){
        
        if (label == nil){
            print("init label")
            
            let labelFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/3)
            label = UILabel(frame: labelFrame)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.text = "test"
            label.layer.borderColor = UIColor.red.cgColor
            label.layer.borderWidth = 1.0
            
            label.layer.cornerRadius = 45
            
            let tapper = UITapGestureRecognizer(target: self, action: #selector(handleChange(_:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapper)
            self.view.addSubview(label)
            
            NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0.0).isActive = true
            
            NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
            
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
            
//            NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0).isActive = true
//            
//            NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .rightMargin, multiplier: 1.0, constant: 0.0).isActive = true
            
        }
        
    }

    func print90DegreesInRadians(){
        var degrees = 90.0
        
        let radians = degToRad(degrees)
        
        print("radians: \(radians)")
        print("pointerRadians: \(pointerToRadians(&degrees))")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let coalesced = event?.coalescedTouches(for: touches.first!)
       handleInput(coalesced)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let coalesced = event?.coalescedTouches(for: touches.first!)
        handleInput(coalesced)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawingView.clear()

    }
    
    func calculateAngle(touch:CGPoint) -> CGFloat{
        let mid = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        let dx = -(touch.x - mid.x)
        let dy = -(touch.y - mid.y)
        let angle = atan2(dx, dy)
        return CGFloat(angle)
    }
    
    func handleInput(_ touches: [UITouch]?){
        
        var pointouches:[CGPoint] = []
        
        if let touches = touches{
            for touch in touches{
                pointouches.append(touch.location(in: self.drawingView))
            }
        }

        let angle = calculateAngle(touch: pointouches.first!)
        let angleString = (angle<0) ? -angle : .pi - angle + .pi
        let labelString = (radians) ? "Radians: " : "Degrees: "
        let convertedAngle = (radians) ? angleString : CGFloat(radToDegrees(Double(angleString)))
        label.text = "\(labelString): \(convertedAngle)"
        drawingView.update(touches: pointouches,angle:angle)
    }
    
}

