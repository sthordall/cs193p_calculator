//
//  GraphViewController.swift
//  Calculator
//
//  Created by Stephan Thordal Larsen on 03/07/15.
//  Copyright (c) 2015 Stephan Thordal. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    var brain : CalculatorBrain? = nil {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if brain != nil {
            title = brain!.latestDescription
        } else {
            title = ""
        }
    }
    
    
    
}
