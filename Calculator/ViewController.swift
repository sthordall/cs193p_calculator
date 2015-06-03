//
//  ViewController.swift
//  Calculator
//
//  Created by Stephan Thordal Larsen on 03/06/15.
//  Copyright (c) 2015 Stephan Thordal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
   
    var userTyping = false
    var operandStack = Array<Double>()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userTyping = true
        }
    }
    
    @IBAction func enter(sender: UIButton) {
        
    }
    
    
    

}

