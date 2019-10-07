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
        var countPosition = 0
        var result: Double
        // looking for multiplication and division
        for index in operationsToReduce {
            print("la boucle commence")
            if index.hasPrefix("x") || index.hasPrefix("/") {
                print("priorité opération")
                let operand = operationsToReduce[countPosition]
                let left = Double(operationsToReduce[countPosition - 1])!
                let right = Double(operationsToReduce[countPosition + 1])!
                switch operand {
                case "x": result = left * right
                case "/": result = left / right
                default: fatalError("Unknown operator !")
                }
                operationsToReduce[countPosition - 1] = "\(result)"
                operationsToReduce.remove(at: countPosition)
                operationsToReduce.remove(at: countPosition)
            } else {
                countPosition += 1
            }
            //after operation priorities
        }
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            print(result)
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
            sendNotification(name: "updateScreen")
            print("print operation to result count\(result)")
        }
        print("print count position \(countPosition)")
        let finalResult = (" = \(operationsToReduce.first!)")
        print(finalResult)
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

}
