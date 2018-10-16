//
//  ViewController.swift
//  Radiator
//
//  Created by Joss Manger on 10/16/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print90DegreesInRadians()
        
    }

    func print90DegreesInRadians(){
        var degrees = 90.0
        
        let radians = degToRad(degrees)
        
        print("radians: \(radians)")
        
        print("pointerRadians: \(pointerToRadians(&degrees))")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
}

