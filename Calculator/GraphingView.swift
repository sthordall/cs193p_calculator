//
//  GraphingView.swift
//  Calculator
//
//  Created by Stephan Thordal Larsen on 08/07/15.
//  Copyright (c) 2015 Stephan Thordal. All rights reserved.
//

import UIKit

protocol GraphDataSource {
    func yForX(xValue: Double) -> Double?
}

class GraphingView: UIView {
    
    private var dataSource: GraphDataSource?
    private let axesDrawer = AxesDrawer()
    private var pointsPerUnit: CGFloat = 10 { didSet{ setNeedsDisplay() } }
    private var centerPoint: CGPoint = CGPoint(x: 0, y: 0) { didSet{ setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        centerPoint = CGPoint(x: (rect.midX), y: (rect.midY ))
        axesDrawer.color = UIColor.blackColor()
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(rect, origin: centerPoint, pointsPerUnit: pointsPerUnit)
        
    }
    
    private func drawGraph(var xValues: [Double], rect: CGRect) {
        //TODO: This Should be a recursive drawing function
        let remainingXValues = xValues
        if remainingXValues.count <= 0 { return }
        let xVal = xValues.removeLast()
        if let yVal = dataSource?.yForX(xVal) {
            drawDataPoint(xValue: xVal, yValue: yVal, origo: centerPoint, rect: rect)
        }
        drawGraph(remainingXValues, rect: rect)
    }
    
    private func drawDataPoint(#xValue: Double, yValue: Double, origo: CGPoint, rect: CGRect) {
        //TODO: Draw point in graph
        
    }
    
}
