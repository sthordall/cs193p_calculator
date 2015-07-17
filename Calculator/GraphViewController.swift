//
//  GraphViewController.swift
//  Calculator
//
//  Created by Stephan Thordal Larsen on 03/07/15.
//  Copyright (c) 2015 Stephan Thordal. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphDataSource {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "pan:"))
        }
    }

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
    
    func yForX(xValue: Double) -> Double? {
        let memento = brain?.variableValues["M"]
        brain?.variableValues["M"] = xValue
        let yValue = brain?.evaluate()
        brain?.variableValues["M"] = memento
        return yValue
    }
    
}
