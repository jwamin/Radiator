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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    var radians = true {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print90DegreesInRadians()
        
        drawingView = AngleDrawView(box:self.view.frame)
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(drawingView)
        
        setupLabel()
        setupConstraints()
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
            label.numberOfLines = 0
            //label.textColor = UIColor.white
            label.textAlignment = .center
            label.layer.borderColor = UIColor.red.cgColor
            label.layer.borderWidth = 1.0
            
            label.layer.cornerRadius = 40
            
            let tapper = UITapGestureRecognizer(target: self, action: #selector(handleChange(_:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapper)
            self.view.addSubview(label)
            

            
//            NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0).isActive = true
//            
//            NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .rightMargin, multiplier: 1.0, constant: 0.0).isActive = true
            
        }
        
    }
    
    func setupConstraints(){
        
        
        //DrawViewConstraints
        NSLayoutConstraint(item: drawingView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.66, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: drawingView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: drawingView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
        
        
        //labelconstriants
        NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.33, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0).isActive = true
    }

    func print90DegreesInRadians(){
        var degrees = 90.0
        
        let radians = degToRad(degrees)
        
        print("radians: \(radians)")
        print("pointerRadians: \(pointerToRadians(&degrees))")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       handleInput(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         handleInput(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawingView.clear()

    }
    
    func calculateAngle(touch:CGPoint) -> CGFloat{
        let mid = CGPoint(x: self.drawingView.bounds.midX, y: self.drawingView.bounds.midY)
        let dx = -(touch.x - mid.x)
        let dy = -(touch.y - mid.y)
        let angle = atan2(dx, dy)
        return CGFloat(angle)
    }
    
    func handleInput(_ touches: Set<UITouch>, with event: UIEvent?){
        print(touches.count)
        var pointouches:[CGPoint] = []
        
        for touch in touches{
            if let coalesced = event?.coalescedTouches(for: touch){
                for touch in coalesced{
                    pointouches.append(touch.location(in: self.drawingView))
                }
            }
        }

        

        let angle = calculateAngle(touch: pointouches.first!)
        let angleString = (angle<0) ? -angle : .pi - angle + .pi
        var labelString = "x:\(round(pointouches.first!.x)) y:\(round(pointouches.first!.y)) \n"
        labelString += (radians) ? "Radians: " : "Degrees: "
        let convertedAngle =  (radians) ? angleString : CGFloat(radToDegrees(Double(angleString)))
        label.text = "\(labelString) \(String(format: "%.3f", convertedAngle))"
        drawingView.update(touches: pointouches,angle:angle)
    }
    
}

