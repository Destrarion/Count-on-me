//
//  Main.swift
//  CountOnMe
//
//  Created by Fabien Dietrich on 04/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

public class Calculator {
    var textScreen: String
    init() {
        textScreen = ""
    }
    func addingAddition() {
        textScreen.append(" + ")
        sendNotification(name: "updateScreen")
    }
    func addingSubstraction() {
        textScreen.append(" - ")
        sendNotification(name: "updateScreen")
    }
    func addingMultiplication() {
        textScreen.append(" x ")
        sendNotification(name: "updateScreen")
    }
    func addingDivision() {
        textScreen.append(" / ")
        sendNotification(name: "updateScreen")
    }
    func startOperation() -> String {
        // Create local copy of operations
        var operationsToReduce = elements
        print("sa continue")
        print(operationsToReduce)
        // looking for multiplication and division
        for (count, index) in operationsToReduce.enumerated() {
            print("la boucle commence")
            if index.hasPrefix("x") || index.hasPrefix("/") {
                print("priorité opération")
                print(operationsToReduce)
                operationsToReduce = reduceOperation(operationToReduce: operationsToReduce, index: count)
                print("after checking priority multiplication : \(operationsToReduce)")
            }
        //after operation priorities
        }
        while operationsToReduce.count > 1 {
            operationsToReduce = reduceOperation(operationToReduce: operationsToReduce, index: 0)
            print("print while for addition : \(operationsToReduce)")
        }
        sendNotification(name: "updateScreen")
        let finalResult = " = \(operationsToReduce.first!)"
        return finalResult
    }
    var elements: [String] {
        print("variable element executé")
        return textScreen.split(separator: " ").map { "\($0)" }
    }
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    var expressionHaveEnoughElement: Bool {
        print("element a bien 3 élément")
        return elements.count >= 3
    }
    var canAddOperator: Bool {
        print("peut bien ajouté un élément")
        return elements.last != "+" && elements.last != "-"
    }
    var expressionHaveResult: Bool {
        return textScreen.firstIndex(of: "=") != nil
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
        var result: Float
        let operand = operationToReduce[count]
        guard let left = Float(operationToReduce[count - 1]) else {return [operationToReduce[count - 1]]}
        guard let right = Float(operationToReduce[count + 1]) else {return [operationToReduce[count + 1]]}
        switch operand {
        case "x": result = left * right
        case "/": result = left / right
        case "+": result = left + right
        case "-": result = left - right
        default: fatalError("Unknown operator !")
        }
        result = roundingValue(value: result)
        print("result :\(result)")
        var operation = operationToReduce
        operation[count - 1] = "\(result)"
        operation.remove(at: count)
        operation.remove(at: count)
        return operation
    }
    func roundingValue(value: Float) -> Float {
        let roundedValue = round ( value * 10000 ) / 10000
        return roundedValue
    }
}
