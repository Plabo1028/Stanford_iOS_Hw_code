//
//  ViewController.swift
//  Calculate
//
//  Created by 傅冠鈞 on 2016/7/10.
//  Copyright © 2016年 Champion_Fu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if "." != digit || !textCurrentlyInDisplay.contains(".") {
                display.text = textCurrentlyInDisplay + digit
            }
//            if "." == digit && textCurrentlyInDisplay.contains(".") {
//                print("Error")
//            }
        }
        else {
            switch digit {
                case ".":
                    display.text = "0."
                case "0":
                    if "0" == display.text {
                        return
                    }
                    fallthrough
                default:
                    display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue : Double {
        get {
            return Double(display.text!)!
            //            because the display could be "hello" can not convert to Double
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    //    private var brain: CaculateBrain = CaculateBrain()
    
    @IBAction func reset(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        displayValue = 0
        history.text = " "
        brain = CalculatorBrain()
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(mathmaticalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        if let description = brain.description {
            history.text = description + (brain.resultIsPending ? "⋯" : "=")
        } else {
            history.text = " "
        }
    }
    
}

extension String {
    func beautifyNumbers() -> String {
        return self.replace(pattern: "\\.0+([^0-9]|$)", with: "$1")
    }
    
    func replace(pattern: String, with replacement: String) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSMakeRange(0, self.characters.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replacement)
    }
}


