//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Stephan Thordal Larsen on 10/06/15.
//  Copyright (c) 2015 Stephan Thordal. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op : Printable {
        case Operand(Double)
        case VariableOperand(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .VariableOperand(let operand):
                    return operand
                case .UnaryOperation(let symbol,_):
                    return symbol
                case .BinaryOperation(let symbol,_):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    var description: String {
        get {
            var finalDescription: String = ""
            var ops = opStack
            
            while(!ops.isEmpty) {
                let desc = describe(ops)
                ops = desc.remainingOps
                finalDescription += desc.result
            }
            
            return finalDescription
        }
    }
    
    var variableValues = [String:Double]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
    }
    
    private func describe(var ops: [Op]) -> (result: String, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .VariableOperand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let (descResult, descRemainingOps) = describe(remainingOps)
                if descResult != "" {
                    return ("\(operation)(\(descResult))", descRemainingOps)
                }
            case .BinaryOperation(_, let operation):
                let (descOp1, descRemainingOps1) = describe(remainingOps)
                if !descOp1.isEmpty {
                    let (descOp2, descRemainingOps2) = describe(descRemainingOps1)
                    if !descOp2.isEmpty {
                        switch "\(operation)" {
                        case "×":
                            return ("\(descOp1) + \(operation) + (\(descOp2))", descRemainingOps2)
                        case "÷":
                            return ("\(descOp2) + \(operation) + (\(descOp1))", descRemainingOps2)
                        case "÷":
                            return ("\(descOp2) + \(operation) + (\(descOp1))", descRemainingOps2)
                        case "+":
                            return ("\(descOp1) + \(operation) + (\(descOp2))", descRemainingOps2)
                        case "−":
                            return ("\(descOp2) + \(operation) + (\(descOp1))", descRemainingOps2)
                        default:
                            return ("\(descOp1) + \(operation) + (\(descOp2))", descRemainingOps2)
                        }
                    }
                }
            }
        }
        return ("", ops)
    }
    
    
    private func evaluate(var ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .VariableOperand(let operand):
                return (variableValues[operand], remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack)")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(operand: String) -> Double? {
        opStack.append(Op.VariableOperand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
