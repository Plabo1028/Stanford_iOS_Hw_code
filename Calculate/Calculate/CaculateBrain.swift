//
//  CaculateBrain.swift
//  Calculate
//
//  Created by 傅冠鈞 on 2016/7/23.
//  Copyright © 2016年 Champion_Fu. All rights reserved.
//

import Foundation

class CaculateBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI), // M_PI,
        "e" : Operation.Constant(M_E), //M_E,
        "√" : Operation.UnaryOperation(sqrt), // sqrt,
        "cos" : Operation.UnaryOperation(cos), // cos
        "±" : Operation.UnaryOperation( {-$0} ),
        "×" : Operation.BinaryOperation( { $0 * $1} ),
//      "×" : Operation.BinaryOperation( { (op1: Double, op2: Double) -> Double in return op1*op2 } )
        "÷" : Operation.BinaryOperation({ $0 / $1}),
        "+" : Operation.BinaryOperation({ $0 + $1}),
        "−" : Operation.BinaryOperation({ $0 -  $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double )
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let fun): accumulator = fun(accumulator)
            case .BinaryOperation(let fun):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: fun, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
//            default: break
            }
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}