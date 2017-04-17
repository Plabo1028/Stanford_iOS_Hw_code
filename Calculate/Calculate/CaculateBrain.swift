//
//  CaculateBrain.swift
//  Calculate
//
//  Created by 傅冠鈞 on 2016/7/23.
//  Copyright © 2016年 Champion_Fu. All rights reserved.
//

import Foundation

class CaculateBrain {
    
    fileprivate var accumulator = 0.0
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    fileprivate var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi), // M_PI,
        "e" : Operation.constant(M_E), //M_E,
        "√" : Operation.unaryOperation(sqrt), // sqrt,
        "cos" : Operation.unaryOperation(cos), // cos
        "±" : Operation.unaryOperation( {-$0} ),
        "×" : Operation.binaryOperation( { $0 * $1} ),
//      "×" : Operation.BinaryOperation( { (op1: Double, op2: Double) -> Double in return op1*op2 } )
        "÷" : Operation.binaryOperation({ $0 / $1}),
        "+" : Operation.binaryOperation({ $0 + $1}),
        "−" : Operation.binaryOperation({ $0 -  $1}),
        "=" : Operation.equals
    ]
    
    fileprivate enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double )
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let fun):
                accumulator = fun(accumulator)
            case .binaryOperation(let fun):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: fun, firstOperand: accumulator)
            case .equals:
                executePendingBinaryOperation()
//            default: break
            }
        }
    }
    
    fileprivate var pending: PendingBinaryOperationInfo?
    
    fileprivate func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    fileprivate struct PendingBinaryOperationInfo {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
