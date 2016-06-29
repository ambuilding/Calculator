//
//  ViewController.swift
//  Calculator
//
//  Created by WangQi on 16/5/15.
//  Copyright © 2016年 WangQi. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new calculator (count = \(calculatorCount))")
        
        brain.addUnaryOperation("z") { [ unowned me = self ] in
            me.display.textColor = UIColor.redColor()
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator left the heap (count = \(calculatorCount))")
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    //Computed properties don’t actually store a value. They  provide a getter and an optional setter to retrieve(get { }) and set other properties and values indirectly(set { }).
    private var displayValue: Double {
        get {
            return Double(display.text!)!
            // If Double("Hello")
        }
        set {
            display.text = String(newValue)
        }
    }

    private var brain = CalculatorBrain()
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let  mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
}

/* 
 touchDigit from 0 to 9;
 Display the digit which you touch
 Force unwrapped
 If let optional binding
 
 
 */