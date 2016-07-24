//
//  ViewController.swift
//  Calculate
//
//  Created by 傅冠鈞 on 2016/7/10.
//  Copyright © 2016年 Champion_Fu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
            //            because the display could be "hello" can not convert to Double
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CaculateBrain()
    //    private var brain: CaculateBrain = CaculateBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(mathmaticalSymbol)
        }
        displayValue = brain.result
    }
    
}

