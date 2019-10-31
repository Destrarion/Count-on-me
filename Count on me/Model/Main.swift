//
//  Main.swift
//  CountOnMe
//
//  Created by Fabien Dietrich on 04/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

public class Calculator {
    var textScreen: String = ""
    var textResult: String = ""
    func addingAddition() {
        ifExpressionAlreadyHaveResult(operatorSymbol: "+")
        ifLastTextisOperator()
        textScreen +=  " + "
        sendNotification(name: "updateScreen")
    }
    func addingSubstraction() {
        ifExpressionAlreadyHaveResult(operatorSymbol: "-")
        ifLastTextisOperator()
        textScreen +=  " - "
        sendNotification(name: "updateScreen")
    }
    func addingMultiplication() {
        ifExpressionAlreadyHaveResult(operatorSymbol: "x")
        ifLastTextisOperator()
        textScreen +=  " x "
        sendNotification(name: "updateScreen")
    }
    func addingDivision() {
        ifExpressionAlreadyHaveResult(operatorSymbol: "/")
        ifLastTextisOperator()
        textScreen +=  " / "
        sendNotification(name: "updateScreen")
    }
    func startOperation() {
        if expressionHaveResult == true {
            return
        }
        if expressionIsCorrect == true && expressionHaveEnoughElement {
            var operationsToReduce = elements
            print(operationsToReduce)
            // looking for multiplication and division
            for (count, index) in operationsToReduce.enumerated() {
                if index.hasPrefix("x") || index.hasPrefix("/") {
                    print("priorité opération")
                    operationsToReduce = reduceOperation(operationToReduce: operationsToReduce,
                                                         index: count - valueRemoved)
                    print("after checking priority multiplication : \(operationsToReduce)")
                }
                //after operation priorities
            }
            while operationsToReduce.count > 1 {
            operationsToReduce = reduceOperation(operationToReduce: operationsToReduce, index: 0 - valueRemoved)
            }
            textResult = operationsToReduce.first!
            let finalResult = " = \(operationsToReduce.first!)"
            textScreen.append(finalResult)
            print(textScreen)
            sendNotification(name: "updateScreen")
        } else {
            if expressionIsCorrect == false {
                sendNotification(name: "alertNotFinishingByNumber")
                return
            }
            if expressionHaveEnoughElement == false {
                sendNotification(name: "alertNotEnoughtElement")
                return
            }
        }
    }
    var elements: [String] {
        return textScreen.split(separator: " ").map { "\($0)" }
    }
    // Error check computed variables
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    var expressionHaveResult: Bool {
        return textScreen.firstIndex(of: "=") != nil
    }
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    private func sendNotification(name: String) {
        let name = Notification.Name(rawValue: name)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    var valueRemoved = 0
    func reduceOperation(operationToReduce: [String], index: Int) -> [String] {
        print("parametre de reduceOperation, operationToReduce: \(operationToReduce), index : \(index)")
        var count = 1
        if index > 0 {
            count = index
        }
        let operand = operationToReduce[count]
        guard let left = Float(operationToReduce[count - 1]) else {return [operationToReduce[count - 1]]}
        guard let right = Float(operationToReduce[count + 1]) else {return [operationToReduce[count + 1]]}
        var result: Float = calculateOperation(left: left, operand: operand, right: right)
        result = roundingValue(value: result)
        var operation = operationToReduce
        operation[count - 1] = "\(result)"
        operation.remove(at: count)
        valueRemoved += 1
        operation.remove(at: count)
        valueRemoved += 1
        return operation
    }
    func calculateOperation(left: Float, operand: String, right: Float) -> Float {
        var result: Float
        switch operand {
        case "x": result = left * right
        case "/": result = left / right
        case "+": result = left + right
        case "-": result = left - right
        default: fatalError("Unknown operator !")
        }
        return result
    }
    func roundingValue(value: Float) -> Float {
        let roundedValue = round ( value * 10000 ) / 10000
        return roundedValue
    }
    func ifLastTextisOperator() {
        let textOnScreen = elements
        if textOnScreen.last == "+" ||
            textOnScreen.last == "-" ||
            textOnScreen.last == "x" ||
            textOnScreen.last == "/" {
            textScreen.removeLast()
            textScreen.removeLast()
            textScreen.removeLast()
        }
    }
    func ifExpressionAlreadyHaveResult (operatorSymbol: String) {
        if expressionHaveResult == true {
            valueRemoved = 0
            textScreen = "\(textResult) + \(operatorSymbol)"
        }
    }
    func clear () {
        textScreen = ""
        valueRemoved = 0
        sendNotification(name: "updateScreen")
    }
    func addingNumber (sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else {return}
        if expressionHaveResult {
            textScreen = ""
            textResult = ""
            sendNotification(name: "updateScreen")
        }
        textScreen.append(numberText)
        sendNotification(name: "updateScreen")
    }
}
