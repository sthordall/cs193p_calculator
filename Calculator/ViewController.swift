//
//  ViewController.swift
//  Calculator
//
//  Created by Stephan Thordal Larsen on 03/06/15.
//  Copyright (c) 2015 Stephan Thordal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //  Outlets
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    
    //  Variables
    var userTyping = false
    var operandStack = Array<Double>()
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userTyping = false
        }
    }
    
    //  Actions
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userTyping = true
        }
    }
    
    @IBAction func appendPoint(sender: UIButton) {
        let point = sender.currentTitle!

        if display.text!.rangeOfString(point) == nil {
            if userTyping {
                display.text = display.text! + point
            } else {
                display.text = "0" + point
                userTyping = true
            }
        }
    }
    
    @IBAction func appendPi() {
        let piValue = M_PI
        if userTyping {
            enter()
        }
        display.text = "\(piValue)"
        enter()
    }
    
    
    @IBAction func enter() {
        userTyping = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        switch operation {
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$0 / $1}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$0 - $1}
        case "√": performOperation {sqrt($0)}
        case "cos": performOperation {cos($0)}
        case "sin": performOperation {sin($0)}
        default: break
        }
    }
    
    //  Helpers
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

}

