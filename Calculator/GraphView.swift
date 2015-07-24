//
//  GraphView.swift
//  Calculator
//
//  Created by Stephan Thordal Larsen on 08/07/15.
//  Copyright (c) 2015 Stephan Thordal. All rights reserved.
//

import UIKit

protocol GraphDataSource {
    func yForX(xValue: CGFloat) -> CGFloat?
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
        
        lastDataPoint = nil
        
        axesDrawer.color = axesColor
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale)
        let xVals = calculateXVals(origin!, rectWidth: rect.width)
        print(xVals.count)
        drawGraph(xVals, rect: rect)
    }
    
    private func calculateXVals(origin: CGPoint, rectWidth: CGFloat) -> [CGFloat] {
        var xVals = [CGFloat]()
        for(var i : CGFloat = 0; i < rectWidth; i++) {
            //var newXVal = i*scaling //*someotherconstanct <------AA, more datapoints!
            let newXVal = (i  - origin.x) * 1/scale
            xVals.append(newXVal)
        }
        return xVals
    }
    
    private func drawGraph(xValues: [CGFloat], rect: CGRect) {
        var remainingXValues = xValues
        if remainingXValues.count <= 0 { return }
        let xVal = remainingXValues.removeLast()
        if let yVal = dataSource?.yForX(xVal)  {
            let scaledYVal = yVal * scale
            let scaledXVal = xVal * scale
            drawDataPoint(xValue: scaledXVal, yValue: scaledYVal, origin: origin!, rect: rect)
        }
        drawGraph(remainingXValues, rect: rect)
    }
    
    var lastDataPoint: CGPoint? = nil
    
    private func drawDataPoint(xValue xValue: CGFloat, yValue: CGFloat, origin: CGPoint, rect: CGRect) {
        //TODO: Draw point in graph
        //Make up for origin location here!
        var dataPoint = origin
        dataPoint.x += xValue
        dataPoint.y += yValue
        
        if lastDataPoint != nil {
            let path = UIBezierPath()
            path.moveToPoint(lastDataPoint!)
            path.addLineToPoint(dataPoint)
            path.stroke()
        }
        
        lastDataPoint = dataPoint
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
