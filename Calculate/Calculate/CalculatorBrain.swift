//
//  CalculatorBrain.swift
//  Calculate
//
//  Created by champion_fu on 18/04/.
//  Copyright © 2017 Champion_Fu. All rights reserved.
//

import Foundation

func factorial(_ op1: Double) -> Double {
    if (op1 <= 1.0) {
        return 1.0
    }
    return op1 * factorial(op1 - 1.0)
}

struct CalculatorBrain {
    
    private var accumulator: (Double, String)?
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private enum Operation {
        case constant(Double, String)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String, String) -> String)
        case equal
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi, "π"),
        "e" : Operation.constant(M_E, "e"),

        "×" : Operation.binaryOperation({ $0 * $1 }, { $0 + "×" + $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }, { $0 + "+" + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }, { $0 + "-" + $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }, { $0 + "+" + $1 }),
        "∙" : Operation.binaryOperation({ $0 + 0.1*$1}, { $0 + "." + $1 }),
        "xʸ" : Operation.binaryOperation({ pow($0, $1)}, { $0 + "^" + $1 }),
        
        "√" : Operation.unaryOperation(sqrt, { "√(" + $0 + ")" }), //sqrt
        "cos" : Operation.unaryOperation(cos, { "cos(" + $0 + ")" }),
        "sin" : Operation.unaryOperation(sin, { "sin(" + $0 + ")" }),
        "tan" : Operation.unaryOperation(tan, { "tan(" + $0 + ")" }),
        "±" : Operation.unaryOperation({-$0}, { "-(" + $0 + ")" }),
        "x⁻¹" : Operation.unaryOperation({ 1 / $0}, {  "(" + $0 + ")⁻¹" }),
        "ln" : Operation.unaryOperation(log, { "ln(" + $0 + ")" }),
        "log" : Operation.unaryOperation(log10, { "log(" + $0 + ")" }),
        "eˣ" : Operation.unaryOperation(exp, { "e^(" + $0 + ")" }),
        "10ˣ" : Operation.unaryOperation({ pow(10, $0) }, { "10^(" + $0 + ")" }),
        "sinh" : Operation.unaryOperation(sinh, { "sinh(" + $0 + ")" }),
        "cosh" : Operation.unaryOperation(cosh, { "cosh(" + $0 + ")" }),
        "tanh" : Operation.unaryOperation(tanh, { "tanh(" + $0 + ")" }),
        "x!" : Operation.unaryOperation(factorial, { "(" + $0 + ")!" }),
        
        "=" : Operation.equal
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value, let symbol):
                accumulator = (value, symbol)
            case .unaryOperation(let function, let description):
                if accumulator != nil {
                    accumulator = (function(accumulator!.0), description(accumulator!.1))
                }
            case .binaryOperation(let function, let description):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, description: description)
                    accumulator = nil
                }
            case .equal:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: (Double, String)
        let description: (String, String) -> String
        
        func perform(with secondOperand: (Double, String)) -> (Double, String) {
            return (function(firstOperand.0, secondOperand.0), description(firstOperand.1, secondOperand.1))
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = (operand, "\(operand)")
    }
    
    var result: Double? {
        get {
            if nil != accumulator {
                return accumulator!.0
            }
            return nil
        }
    }
    
    var description: String? {
        get {
            if resultIsPending {
                return pendingBinaryOperation!.description(pendingBinaryOperation!.firstOperand.1, "")
            } else {
                return accumulator!.1
            }
        }
    }
}
