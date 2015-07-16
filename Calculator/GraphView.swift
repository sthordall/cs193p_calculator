//
//  GraphView.swift
//  Calculator
//
//  Created by Stephan Thordal Larsen on 08/07/15.
//  Copyright (c) 2015 Stephan Thordal. All rights reserved.
//

import UIKit

protocol GraphDataSource {
    func yForX(xValue: Double) -> Double?
}

class GraphView: UIView {
    
    var dataSource: GraphDataSource?
    private let axesDrawer = AxesDrawer()
    private var pointsPerUnit: CGFloat = 10 { didSet{ setNeedsDisplay() } }
    private var centerPoint: CGPoint = CGPoint(x: 0, y: 0) { didSet{ setNeedsDisplay() } }
    private var scale: CGFloat = 1 { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        centerPoint = CGPoint(x: (rect.midX), y: (rect.midY ))
        axesDrawer.color = UIColor.blackColor()
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(rect, origin: centerPoint, pointsPerUnit: scale)
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
    
    private func drawDataPoint(xValue xValue: Double, yValue: Double, origo: CGPoint, rect: CGRect) {
        //TODO: Draw point in graph
        print(contentScaleFactor)
        print(axesDrawer.minimumPointsPerHashmark)
        
    }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
            
        }
    }
    
}
