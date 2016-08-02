//
//  ViewController.swift
//  Calculator
//
//  Created by WangQi on 16/5/15.
//  Copyright © 2016年 WangQi. All rights reserved.
//

import UIKit

// var calculatorCount = 0

class ViewController: UIViewController {

    private let defaultDisplayText = "0"
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false {
        didSet {
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfFloatingPointNumber = false
            }
        }
    }
    
    private var userIsInTheMiddleOfFloatingPointNumber = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        calculatorCount += 1
//        print("Loaded up a new calculator (count = \(calculatorCount))")
        
        brain.addUnaryOperation("z") { [ unowned me = self ] in
            me.display.textColor = UIColor.redColor()
            return sqrt($0)
        }
        
        
        adjustButtonLayout(view, portrait: traitCollection.horizontalSizeClass == .Compact && traitCollection.verticalSizeClass == .Regular)
    }
    
//    deinit {
//        calculatorCount -= 1
//        print("Calculator left the heap (count = \(calculatorCount))")
//    }
    
    //Computed properties don’t actually store a value. They  provide a getter and an optional setter to retrieve(get { }) and set other properties and values indirectly(set { }).
    
    private var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue ?? nil
            //return Double(display.text!)! // If Double("Hello")
//            if let text = display.text, value = NSNumberFormatter().numberFromString(text)?.doubleValue {
//                return value
//            }
//            return nil
        }
        set {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            formatter.maximumFractionDigits = Constants.DecimalDigits
            
            display.text = formatter.stringFromNumber(newValue!)
        }
    }
    
    private struct Constants {
        static let DecimalDigits = 6
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == decimalSeparator {
            if userIsInTheMiddleOfFloatingPointNumber {
                return
            }
            if !userIsInTheMiddleOfTyping {
                digit = defaultDisplayText + decimalSeparator
            }
            userIsInTheMiddleOfFloatingPointNumber = true
        }
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
    }
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue!)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    

//    private var brain = CalculatorBrain(decimalDigits: Constants.DecimalDigits)
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
    
    
    @IBAction func clearEverything(sender: UIButton) {
        savedProgram = nil
        display.text = defaultDisplayText
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func backSpace(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            if var text = display.text {
                text.removeAtIndex(text.endIndex.predecessor())
                if text.isEmpty {
                    text = defaultDisplayText
                    userIsInTheMiddleOfTyping = false
                }
                display.text = text
            }
        }
        
    }
    
    private let decimalSeparator = NSNumberFormatter().decimalSeparator!
    
    private func adjustButtonLayout(view: UIView, portrait: Bool) {
        for subview in view.subviews {
            if subview.tag == 1 {
                subview.hidden = portrait
            } else if subview.tag == 2 {
                subview.hidden = !portrait
            }
            
            if let button = subview as? UIButton {
                button.setBackgroundColor(UIColor.blackColor(), forState: .Highlighted)
                if button.tag == 3 {
                    button.setTitle(decimalSeparator, forState: .Normal)
                }
            } else if let stack = subview as? UIStackView {
                adjustButtonLayout(stack, portrait: portrait);
            }
            
        }
    }

    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        adjustButtonLayout(view, portrait: newCollection.horizontalSizeClass == .Compact && newCollection.verticalSizeClass == .Regular)
    }

}

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(image, forState: state)
    }
}

/* 
 touchDigit from 0 to 9;
 Display the digit which you touch
 Force unwrapped
 If let optional binding
 */