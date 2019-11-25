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
    // function to add an addition or removing the negative number symbol
    func addingAddition() {
        if emptyScreen() || expressionHaveError {
            return
        } else if symbolSubstractionAlreadyAdded() {
            removeLastText(number: 1)
            sendNotification(name: "updateScreen")
        } else {
            addingOperationAfterResult(operatorSymbol: "+")
            replaceLastOperator()
            textScreen +=  " + "
            sendNotification(name: "updateScreen")
        }
    }
    // function to add substraction and the negative number to the operation
    func addingSubstraction() {
        if emptyScreen() || expressionHaveError {
            clear()
            textScreen += "-"
        } else if textScreen == "-"{
            return
        } else if symbolSubstractionAlreadyAdded() == true {
            removeLastText(number: 3)
            textScreen += "- -"
        } else if lastTextIsOperator() {
            textScreen += "-"
        } else if expressionHaveResult == true {
        addingOperationAfterResult(operatorSymbol: "-")
        } else {
        textScreen +=  " - "
        }
    sendNotification(name: "updateScreen")
    }
    func addingMultiplication() {
        if emptyScreen() || expressionHaveError {
            return
        } else if symbolSubstractionAlreadyAdded() {
            removeLastText(number: 4)
            sendNotification(name: "updateScreen")
        }
        addingOperationAfterResult(operatorSymbol: "x")
        replaceLastOperator()
        textScreen +=  " x "
        sendNotification(name: "updateScreen")
    }
    // function for adding division
    func addingDivision() {
        if emptyScreen() || expressionHaveError {
            return
        } else if symbolSubstractionAlreadyAdded() {
            removeLastText(number: 4)
            sendNotification(name: "updateScreen")
        }
        addingOperationAfterResult(operatorSymbol: "/")
        replaceLastOperator()
        textScreen +=  " / "
        sendNotification(name: "updateScreen")
    }
    // function to add dot to a number
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
    /* Method called when pressing the Equal Button
        
        It check first the priority of operation and reduceOperation multiplication and division first.
     
        Then in a second time he reduce the operation for addition and susbtraction.
     
        It check also if the operation is correct.
     
        If the operation isn't well written, it gonna send notification to alert the user with an alert.
 
    */
    func startOperation() {
        if expressionHaveResult == true {
            return
        }
        if expressionIsCorrect == true && expressionHaveEnoughElement {
            var operationsToReduce = elements
            print(operationsToReduce)
            textScreen.append(" = ")
            print(operationsToReduce)
            // looking for multiplication and division
            for (count, index) in operationsToReduce.enumerated() {
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
    // Variable that split the string variable operation to an array.
    private var elements: [String] {
        return textScreen.split(separator: " ").map { "\($0)" }
    }
    // Error check computed variables
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    // Boolean used to check if there's a result already done.
    private var expressionHaveResult: Bool {
        return textScreen.firstIndex(of: "=") != nil
    }
    // Boolean to check when if the last operation was an error.
    private var expressionHaveError: Bool {
        if textScreen == "Start a new operation" {
            return true
        }
        return false
    }
    // Method that check if the expression do not finish by an operand
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    // Method created to simplify sending a notification
    private func sendNotification(name: String) {
        let name = Notification.Name(rawValue: name)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    // Variable used to count how much value as been rethrieved to prevent an out of range when reducing operation.
    private var valueRemoved = 0
    // Method that gonna place the number to their emplacement to calculate the operation.
    private func reduceOperation(operationToReduce: [String], index: Int) -> [String] {
        print("parametre de reduceOperation, operationToReduce: \(operationToReduce), index : \(index)")
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
        } else {
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
    // Method called for rounding the result.
    private func roundingValue(value: Float) -> Float {
        let roundedValue = round(value * 10000 ) / 10000
        return roundedValue
    }
    // Method called for replacing the last operator
    private func replaceLastOperator() {
        if lastTextIsOperator() == true {
            if textScreen == "-"{
                removeLastText(number: 1)
            } else {
            // 12 + (click on + button ) 1 + (see lastTextIsOperator
            removeLastText(number: 3)
            }
        }
    }
    // Boolean if the last text is one of the operator symbol
    private func lastTextIsOperator() -> Bool {
        let textOnScreen = elements
        if textOnScreen.last == "+" ||
    // The error that concern the issue after result typing - number is here
            textOnScreen.last == "-" ||
            textOnScreen.last == "x" ||
            textOnScreen.last == "/" {
            return true
        }
        return false
    }
    // func called after making a result if the user want to continue with the result value
    private func addingOperationAfterResult (operatorSymbol: String) {
        if expressionHaveError == true {
            textScreen = ""
        }
        if textScreen == "Start a new operation" {
            return
        }
        if expressionHaveResult == true {
            valueRemoved = 0
            textScreen = "\(textResult) \(operatorSymbol) "
            sendNotification(name: "updateScreen")
        }
    }
    // clear everything
    func clear () {
        textScreen = ""
        valueRemoved = 0
        sendNotification(name: "updateScreen")
    }
    // func called when adding number
    func addingNumber (number: String) {
        if expressionHaveResult || expressionHaveError {
            textScreen = ""
            textResult = ""
            sendNotification(name: "updateScreen")
        }
        textScreen.append(number)
        sendNotification(name: "updateScreen")
    }
    // function to prevent error from divide by zero
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
        } else {
            return false
        }
    }
    // function to do not get 3 "-" in a row or "--"
    private func symbolSubstractionAlreadyAdded() -> Bool {
        var countElement: Int = -1
        let operation = elements
        for _ in elements {
            countElement += 1
        }
        let operatorList = ["+", "-", "x", "/"]
        if expressionHaveEnoughElement {
            for operatorSymbol in operatorList {
                if operation[countElement - 1] == operatorSymbol && operation[countElement] == "-" {
                    return true
                }
            }
        }
        return false
    }
    // func for factoring code when removing last
    private func removeLastText(number: Int) {
        let numberToRemove = number
        for _ in 1...numberToRemove {
            textScreen.removeLast()
        }
    }
    // Boolean used to check if the last number contain a dot.
    private func lastTextIsDot () -> Bool {
        let operation = elements
        if textScreen != ""{
            if (operation.last?.hasSuffix("."))! {
                return true
            }
        }
        return false
    }
    private func dotAlreadyAddedToLastNumber() -> Bool {
        let operation = elements
        if textScreen != ""{
            if (operation.last?.contains("."))! {
                return true
            }
        }
        return false
    }
}
