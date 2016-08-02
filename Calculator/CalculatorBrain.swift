//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by WangQi on 16/5/15.
//  Copyright © 2016年 WangQi. All rights reserved.
//

import Foundation

//func multiply(op1: Double, op2: Double) -> Double {
//    return op1 * op2
//}

class CalculatorBrain {
    
    private var accumulator = 0.0
    var internalPromgram = [AnyObject]()
    
//    var decimalDigits: Int
//    
//    init(decimalDigits:Int) {
//        self.decimalDigits = decimalDigits
//    }
    
    func setOperand(operand: Double) {
        accumulator = operand
//        let formatter = NSNumberFormatter()
//        formatter.numberStyle = .DecimalStyle
//        formatter.maximumFractionDigits = decimalDigits
        internalPromgram.append(operand)
    }
    
    func addUnaryOperation(symbol: String, operation: (Double) -> Double) {
        operations[symbol] = Operation.UnaryOperation(operation)
    }
    
    private var operations: Dictionary<String, Operation> = [
    "π" : Operation.Constant(M_PI),
    "e" : Operation.Constant(M_E),
    "±" : Operation.UnaryOperation({ -$0 }),
    "%" : Operation.UnaryOperation({ $0 / 100 }),
    "√" : Operation.UnaryOperation(sqrt),
    "cos" : Operation.UnaryOperation(cos),
    "sin" : Operation.UnaryOperation(sin),
    "×" : Operation.BinaryOperation({ $0 * $1 }), // closure
    "÷" : Operation.BinaryOperation({ $0 / $1 }),
    "+" : Operation.BinaryOperation({ $0 + $1 }),
    "-" : Operation.BinaryOperation({ $0 - $1 }),
    "rand" : Operation.NullaryOperation(drand48, "rand()"),
    "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case NullaryOperation(() -> Double, String)
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalPromgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                
                executePendingBinaryOperation()
                
                pending = pendingBinaryOperationInfo(binaryFunction: function, firstOprand: accumulator)
                
            case .NullaryOperation(let function, _):
                accumulator = function()
                //descriptionAccumulator = descriptionValue
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOprand, accumulator)
            pending = nil
        }
    }
    
    private var pending: pendingBinaryOperationInfo?
    
    struct pendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOprand: Double
    }
    
    // The aliased name can be used instead of the existing type everywhere in the program.
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalPromgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalPromgram.removeAll()
    }
    
    // read-only property
    var result: Double {
        get {
            return accumulator
        }
    }
    
}