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
            if let value = NSNumberFormatter().numberFromString(display.text!) {
                let doubleValue = value.doubleValue
                if doubleValue != 0 {
                    return doubleValue
                }
            }
            return nil
        }
        set{
            if newValue != nil {
                display.text = "\(newValue!)"
            } else {
                display.text = "ERROR"
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
    
    @IBAction func updateHistory() {
        history.text = brain.description
    }
    
    @IBAction func enter() {
        userTyping = false
        if let value = displayValue {
            displayValue = brain.pushOperand(value)
        }
        updateHistory()
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
            showResult(brain.performOperation(operation))
        }
    }
    
    private func showResult(var result: Double?) {
        displayValue = result
        display.text = "= " + display.text!
        updateHistory()
    }
    
}

