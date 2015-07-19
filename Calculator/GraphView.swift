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

@IBDesignable
class GraphView: UIView {
    
    var dataSource: GraphDataSource?
    private let axesDrawer = AxesDrawer()
    
    var origin: CGPoint? = nil { didSet{ setNeedsDisplay() } }
    
    @IBInspectable
    var scale: CGFloat = 1 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var axesColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        if origin == nil {
            origin = CGPoint(x: (rect.midX), y: (rect.midY ))
        }
        
        axesDrawer.color = axesColor
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale)
        let xVals = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        drawGraph(xVals, rect: rect)
    }
    
    private func drawGraph(xValues: [Double], rect: CGRect) {
        //TODO: This Should be a recursive drawing function
        var remainingXValues = xValues
        if remainingXValues.count <= 0 { return }
        let xVal = remainingXValues.removeLast()
        if let yVal = dataSource?.yForX(xVal) {
            drawDataPoint(xValue: xVal, yValue: yVal, origin: origin!, rect: rect)
        }
        drawGraph(remainingXValues, rect: rect)
    }
    
    private func drawDataPoint(xValue xValue: Double, yValue: Double, origin: CGPoint, rect: CGRect) {
        //TODO: Draw point in graph
        print("X and Y Coordinates: \(xValue) , \(yValue)")
    }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
            
        }
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            origin!.y += translation.y
            origin!.x += translation.x
            gesture.setTranslation(CGPointZero, inView: self)
            setNeedsDisplay()
        default: break
        }
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            let tapPoint = gesture.locationInView(self)
            origin = tapPoint
        }
    }
    
}
