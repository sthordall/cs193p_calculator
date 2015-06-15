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
    private var brain = CalculatorBrain()
    private var userTyping = false
    private var operandStack = Array<Double>()
    private var displayValue: Double? {
        get{
            if display.text!.rangeOfString("=") == nil {
                display.text = display.text!.stringByReplacingOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            let value = NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            if value == 0 {
                return nil
            }
            return value
        }
        set{
            if newValue != nil {
                display.text = "\(newValue!)"
            } else {
                display.text = "0"
            }
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
    
    @IBAction func appendHistory(sender: UIButton) {
        history.text = history.text! + " "  + sender.currentTitle!
    }
    
    @IBAction func enter() {
        userTyping = false
        if let value = displayValue {
            if let result = brain.pushOperand(value) {
                displayValue = result
            }
        }
    }
    
    @IBAction func clear() {
        history.text = ""
        displayValue = nil
        operandStack = Array<Double>()
        userTyping = false
    }
    
    @IBAction func backspace() {
        if userTyping {
            display.text = dropLast(display.text!)
            if count(display.text!) == 0 {
                displayValue = nil
            }
        }
    }
    
    @IBAction func invertSign() {
        if let value = displayValue {
            displayValue = value * (-1)
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
        }
    }
    
    //  Helpers
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            showResult()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            showResult()
        }
    }
    
    private func showResult() {
        display.text = "= \(displayValue!)"
        enter()
    }
}

