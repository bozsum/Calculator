//
//  ViewController.swift
//  Calculator
//
//  Created by Jetsada Wareepot on 6/25/2561 BE.
//  Copyright © 2561 BE Jetsada Wareepot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    var hasOperand = false
    var hasOperator = false
    var operatorArray = [String]()
    var operandArray = [Double]()
    var lastOperator: String?
    var lastResult: Double = 0
    var hasDecimal = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleButtonPress(_ sender: UIButton) {
        let currentText = resultLabel.text!
        let textLabel = sender.titleLabel?.text
        if let text = textLabel {
            switch text {
            case "Clear" :
                hasOperand = false
                hasOperator = false
                hasDecimal = false
                operatorArray.removeAll()
                operandArray.removeAll()
                lastOperator = nil
                resultLabel.text = ""
            case "+", "*", "/", "-":
                if !hasOperator && hasOperand {
                    hasOperator = true
                    lastOperator = text
                    operandArray.append(Double(currentText)!)
                    
                    if checkPriotyToCalculate(text) {
                        let result = calculate()
                        resultLabel.text = "\(result)"
                    }
                } else if hasOperator && hasOperand {
                    lastOperator = text
                }
            case "=":
                var result: Double = 0
                if hasOperand && operatorArray.count > 0 {
                    operandArray.append(Double(currentText)!)
                    while operandArray.count > 0 {
                        result = calculate()
                    }
                } else if hasOperand {
                    result = lastResult
                }
                resultLabel.text = "\(result)"
            case "+/-":
                if hasOperand {
                    resultLabel.text = "\(-Double(currentText)!)"
                }
            default:
                if hasOperator {
                    resultLabel.text = "\(text)"
                    operatorArray.append(lastOperator!)
                    lastOperator = nil
                    hasOperator = false
                    hasDecimal = false
                } else {
                    if text == "." && !hasDecimal && hasOperand {
                        hasDecimal = true
                        resultLabel.text = "\(currentText)\(text)"
                    } else if text != "." {
                        hasOperand = true
                        resultLabel.text = "\(currentText)\(text)"
                    }
                }
            }
        }
    }
    
    func calculate() -> Double {
        var tempResult: Double = 0
        if operandArray.count > 1 {
            let secondValue = operandArray.popLast()!
            let firstValue = operandArray.popLast()!
            let operatorValue = operatorArray.popLast()!
            tempResult = mathFunction(operatorValue, firstValue, secondValue)
            operandArray.append(tempResult)
        } else {
            tempResult = operandArray.popLast()!
        }
        lastResult = tempResult
        return tempResult
    }
    
    func mathFunction(_ operatorVal: String, _ firstValue: Double, _ secondValue: Double) -> Double {
        switch operatorVal {
        case "+":
            return firstValue + secondValue
        case "-":
            return firstValue - secondValue
        case "*":
            return firstValue * secondValue
        case "/":
            return firstValue / secondValue
        default:
            return 0
        }
    }
    
    func checkPriotyToCalculate(_ currentOperator: String) -> Bool {
        if (operatorArray.count > 0) {
            let lastOperatorIsFirstPriority = isFirstPriority(operatorArray[operatorArray.count-1])
            let currentOperatorIsFirstPriority = isFirstPriority(currentOperator)
            return lastOperatorIsFirstPriority || !currentOperatorIsFirstPriority
        }
        return false
    }
    
    func isFirstPriority(_ op: String) -> Bool {
        switch op {
        case "*", "/":
            return true
        default:
            return false
        }
    }
}

