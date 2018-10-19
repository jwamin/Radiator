//
//  ViewController.swift
//  Radiator
//
//  Created by Joss Manger on 10/16/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    //UI Elements
    
    var drawVC:DrawViewController!
    var label:UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawVC = DrawViewController()
        self.addChild(drawVC)
        self.view.addSubview(drawVC.view)
        self.view.backgroundColor = UIColor.black
        //setupLabel()
        setupConstraints()
    }
    
    func setupConstraints(){
        
        print("adding constraints")
        //DrawViewConstraints
        //NSLayoutConstraint(item: drawVC.view, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.66, constant: 0.0).isActive = true
         NSLayoutConstraint(item: drawVC.view, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: drawVC.view, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: drawVC.view, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
       
        
        NSLayoutConstraint(item: drawVC.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
            NSLayoutConstraint(item: drawVC.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
        //NSLayoutConstraint(item: drawVC.view, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        
        //labelconstriants
//        NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0.0).isActive = true
//
//        NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
//
//        NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    func setupLabel(){
        
        if (label == nil){
            print("init label")
            
            let labelFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/3)
            label = UILabel(frame: labelFrame)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.layer.borderColor = UIColor.red.cgColor
            label.layer.borderWidth = 1.0
            
            label.layer.cornerRadius = 40
            
            let tapper = UITapGestureRecognizer(target: drawVC, action: #selector(drawVC.handleChange(_:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapper)
            self.view.addSubview(label)
            
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        //
    }

}

