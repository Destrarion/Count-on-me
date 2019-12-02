//
//  Main.swift
//  CountOnMe
//
//  Created by Fabien Dietrich on 04/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//
import Foundation

public class Calculator {
    var textScreen: String = ""
    private var textResult: String = ""
    // func called when adding number
    func add(number: String) {
        if expressionHaveResult || expressionHaveError {
            textScreen = ""
            textResult = ""
            sendNotification(name: "updateScreen")
        }
        textScreen.append(number)
        sendNotification(name: "updateScreen")
    }
    /// This function is use to add operator. It change for operator case, only multiplication and division is mutual.
    /// - Symbols case :
    ///     - If there is a operation already added, they will replace the last one.
    ///     - Substraction symbol as last operator and add a substraction symbol again, add a negative symbol.
    ///     - If a negative symbol added, when want to add a addition, it remove the negative symbol instead.
    /// - Operator Symbol:
    ///     - Addition: Add a addition symbol or remve a negative symbol.
    ///     - Substraction: Add a symbol of substraction or add a negative symbol.
    ///     - Multiplication: Add
    ///     - Division :
    /// - Parameters:
    ///     - symbol: Define the symbol of operand you want to add.
    func add(operator symbol: String) {
        switch symbol {
        case "+":
            if emptyScreen() || expressionHaveError {
                    return
                } else if negativeSymbolAlreadyAdded() {
                    removeLastText(number: 1)
                } else if lastTextIsOperator() {
                    replaceLastOperator(" + ")
                } else {
                    addingOperationAfterResult(operatorSymbol: "+")
                    textScreen +=  " + "
                }
            sendNotification(name: "updateScreen")
        case "-":
            if emptyScreen() || expressionHaveError {
                    clear()
                    textScreen += "-"
                } else if textScreen == "-"{
                    return
                } else if negativeSymbolAlreadyAdded() == true {
                    removeLastText(number: 3)
                    textScreen += "- -"
                } else if lastTextIsOperator() {
                    textScreen += "-"
                } else if expressionHaveResult == true {
                addingOperationAfterResult(operatorSymbol: "-")
                } else {
                textScreen +=  " - "
            }
        default:
            if emptyScreen() || expressionHaveError {
                    return
                } else if negativeSymbolAlreadyAdded() {
                    removeLastText(number: 4)
                    textScreen += " \(symbol) "
                } else if lastTextIsOperator() {
                    replaceLastOperator(" \(symbol) ")
                } else {
                addingOperationAfterResult(operatorSymbol: symbol)
                textScreen +=  " \(symbol) "
                }
            }
        sendNotification(name: "updateScreen")
    }
    /// Function to add dot
    /// If it add 0. when it got no prefix that as been a number
    func addDot() {
        if lastTextIsDot() || dotAlreadyAddedToLastNumber() {
            return
        }
        if emptyScreen() || expressionHaveError {
            textScreen = "0."
        } else if lastTextIsOperator() {
            textScreen.append("0.")
        } else {
            textScreen += "."
        }
        sendNotification(name: "updateScreen")
    }
    /// Method called when pressing the Equal Button
    /// It check first the priority of operation and reduceOperation multiplication and division first.
    /// Then in a second time he reduce the operation for addition and susbtraction.
    /// It check also if the operation is correct.
    /// If the operation isn't well written, it gonna send notification to alert the user with an alert.
    func startOperation() {
        if expressionHaveResult == true {
            return
        }
        if expressionIsCorrect == true && expressionHaveEnoughElement {
            var operationsToReduce = elements
            textScreen.append(" = ")
            // looking for multiplication and division
            for (count, index) in operationsToReduce.enumerated() {
                if operationsToReduce[0] == "Start a new operation"{
                    textScreen = "Start a new operation"
                    sendNotification(name: "updateScreen")
                    return
                }
                if index.hasPrefix("x") || index.hasPrefix("/") {
                    operationsToReduce = reduceOperation(operationToReduce: operationsToReduce,
                        index: count - valueRemoved)
                }
            }
            while operationsToReduce.count > 1 {
            operationsToReduce = reduceOperation(operationToReduce: operationsToReduce, index: 0 - valueRemoved)
            }
            textResult = operationsToReduce.first!
            let finalResult = "\(operationsToReduce.first!)"
            textScreen.append(finalResult)
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
    /// Variable that split the string variable operation to an array.
    private var elements: [String] {
        return textScreen.split(separator: " ").map { "\($0)" }
    }
    /// Error check computed variables
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    /// Boolean used to check if there's a result already done.
    private var expressionHaveResult: Bool {
        return textScreen.firstIndex(of: "=") != nil
    }
    /// Boolean to check when if the last operation was an error.
    private var expressionHaveError: Bool {
        if textScreen == "Start a new operation" {
            return true
        }
        return false
    }
    /// Method that check if the expression do not finish by an operand
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    /// Method created to simplify sending a notification
    private func sendNotification(name: String) {
        let name = Notification.Name(rawValue: name)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    /// Variable used to count how much value as been rethrieved to prevent an out of range when reducing operation.
    private var valueRemoved = 0
    /// Method that gonna place the number to their emplacement to calculate the operation.
    private func reduceOperation(operationToReduce: [String], index: Int) -> [String] {
        var count = 1
        if index > 0 {
            count = index
        }
        let operand = operationToReduce[count]
        guard let left = Float(operationToReduce[count - 1]) else {return [operationToReduce[count - 1]]}
        guard let right = Float(operationToReduce[count + 1]) else {return [operationToReduce[count + 1]]}
        var result: Float
        if divideByZero(numberRight: right, operand: operand) {
            sendNotification(name: "errorDivideByZero")
            clear()
            return ["Start a new operation"]
        }
        result = calculateOperation(left: left, operand: operand, right: right)
        result = roundingValue(value: result)
        var operation = operationToReduce
        operation[count - 1] = "\(result)"
        operation.remove(at: count)
        valueRemoved += 1
        operation.remove(at: count)
        valueRemoved += 1
        return operation
    }
    /// Returns the operation of 3 elements
    /// from the given components.
    ///
    /// - Parameters:
    ///     - left: The number located to the left of the operand
    ///     - operand: To define which operation we must use ( + , - ,  x ,  /  )
    ///     - right: The number located to the right of the operand
    private func calculateOperation(left: Float, operand: String, right: Float) -> Float {
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
    /// Method called for rounding the result.
    private func roundingValue(value: Float) -> Float {
        let roundedValue = round(value * 10000 ) / 10000
        return roundedValue
    }
    /// Method called for replacing the last operator
    private func replaceLastOperator(_ symbol: String) {
        if lastTextIsOperator() == true {
            if textScreen == "-"{
                removeLastText(number: 1)
            } else {
            // 12" + "1 , removeLastText count the + and space
            removeLastText(number: 3)
            textScreen.append(symbol)
            }
        }
    }
    /// Boolean if the last text is one of the operator symbol
    private func lastTextIsOperator() -> Bool {
        if elements.last == "+" ||
            elements.last == "-" ||
            elements.last == "x" ||
            elements.last == "/" {
            return true
        }
        return false
    }
    /// func called after making a result if the user want to continue with the result value
    private func addingOperationAfterResult (operatorSymbol: String) {
        if expressionHaveResult == true {
            valueRemoved = 0
            textScreen = "\(textResult) \(operatorSymbol) "
            sendNotification(name: "updateScreen")
        }
    }
    /// clear everything
    func clear () {
        textScreen = ""
        valueRemoved = 0
        sendNotification(name: "updateScreen")
    }
    /// function to prevent error from divide by zero
    private func divideByZero (numberRight: Float, operand: String) -> Bool {
        var rightIsZero = false
        if operand == "/"{
            if numberRight == 0 {
                rightIsZero = true
                return rightIsZero
            }
        }
        return false
    }
    private func emptyScreen() -> Bool {
        if textScreen == ""{
            return true
        }
        return false
    }
    /// function to do not get 3 "-" in a row or "--"
    private func negativeSymbolAlreadyAdded() -> Bool {
        var countElement: Int = -1
        for _ in elements {
            countElement += 1
        }
        let operatorList = ["+", "-", "x", "/"]
        if expressionHaveEnoughElement {
            for operatorSymbol in operatorList {
                if elements[countElement - 1] == operatorSymbol && elements[countElement] == "-" {
                    return true
                }
            }
        }
        return false
    }
    /// func for factoring code when removing last
    private func removeLastText(number: Int) {
        let numberToRemove = number
        for _ in 1...numberToRemove {
            textScreen.removeLast()
        }
    }
    /// Boolean used to check if the last number contain a dot.
    private func lastTextIsDot () -> Bool {
        if textScreen != ""{
            if (elements.last?.hasSuffix("."))! {
                return true
            }
        }
        return false
    }
    private func dotAlreadyAddedToLastNumber() -> Bool {
        if textScreen != ""{
            if (elements.last?.contains("."))! {
                return true
            }
        }
        return false
    }
}
