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
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(sender: UIButton) {
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
    
    @IBAction func performOperation(sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathmaticalSymbol = sender.currentTitle {
            if mathmaticalSymbol == "π" {
                display.text = String(M_PI)
            }
        }
    }

}
