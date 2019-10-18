//
//  Main.swift
//  CountOnMe
//
//  Created by Fabien Dietrich on 04/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

public class Calculator {
    var textScreen: String
    init() {
        textScreen = ""
    }
    func addingAddition() {
        ifLastTextisOperator()
        textScreen +=  " + "
        sendNotification(name: "updateScreen")
    }
    func addingSubstraction() {
        ifLastTextisOperator()
        textScreen +=  " - "
        sendNotification(name: "updateScreen")
    }
    func addingMultiplication() {
        ifLastTextisOperator()
        textScreen +=  " x "
        sendNotification(name: "updateScreen")
    }
    func addingDivision() {
        ifLastTextisOperator()
        textScreen +=  " / "
        sendNotification(name: "updateScreen")
    }
    func startOperation() -> Any {
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Error!", message: "Enter a correct expression!", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC.present(alertVC, animated: true, completion: nil)
        }
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Error!", message: "Start a new calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC.present(alertVC, animated: true, completion: nil)
        }
        var operationsToReduce = elements
        print(operationsToReduce)
        // looking for multiplication and division
        for (count, index) in operationsToReduce.enumerated() {
            if index.hasPrefix("x") || index.hasPrefix("/") {
                print("priorité opération")
                operationsToReduce = reduceOperation(operationToReduce: operationsToReduce, index: count)
                print("after checking priority multiplication : \(operationsToReduce)")
            }
        //after operation priorities
        }
        while operationsToReduce.count > 1 {
            operationsToReduce = reduceOperation(operationToReduce: operationsToReduce, index: 0)
        }
        sendNotification(name: "updateScreen")
        let finalResult = " = \(operationsToReduce.first!)"
        return finalResult
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
        operation.remove(at: count)
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
        if textOnScreen.last == "+" || textOnScreen.last == "-" || textOnScreen.last == "x" || textOnScreen.last == "/" {
            textScreen.removeLast()
            textScreen.removeLast()
            textScreen.removeLast()
        }
    }
}
