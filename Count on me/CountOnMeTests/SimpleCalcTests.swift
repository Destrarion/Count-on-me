//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    let calculator = Calculator()

    func testGivenEmptyScreen_WhenAddingCalculAndAddingNegativeNumber_ThenCalculDonotDeleteLastOperator() {
        calculator.addingNumber(number: "2")
        calculator.add(operator: "x")
        calculator.add(operator: "-")
        calculator.addDot()
        calculator.addDot()
        calculator.addingNumber(number: "1")
        calculator.startOperation()
        XCTAssert(calculator.textScreen == "2 x -0.1 = -0.2")
    }
    func testGivenOperation_WhenAddingSubstractionAndNumber_ThenAddNegativeNumber() {
        calculator.textScreen = "2 x "
        calculator.add(operator: "-")
        calculator.addingNumber(number: "1")
        XCTAssert(calculator.textScreen == "2 x -1")
    }
    func testNotificationUpdateScreen() {
        expectation(forNotification: NSNotification.Name(rawValue: "updateScreen"), object: nil, handler: nil)
        calculator.textScreen = "2 + 5"
        calculator.startOperation()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    func testGivenCalculDividedByZero_WhenStartOperation_ThenAlertUIError() {
        expectation(forNotification: NSNotification.Name(rawValue: "errorDivideByZero"), object: nil, handler: nil)
        calculator.addDot()
        calculator.add(operator: "/")
        calculator.addingNumber(number: "0")
        calculator.startOperation()
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssert(calculator.textScreen == "Start a new operation")
    }
    func testGivenEmptyCalcul_WhenAddingAdditionAfterSubstraction_ThenRemoveNegativeAndSubstractionNumber() {
        calculator.addingNumber(number: "550")
        calculator.add(operator: "+")
        calculator.addingNumber(number: "39")
        calculator.add(operator: "-")
        calculator.add(operator: "-")
        calculator.add(operator: "/")
        calculator.addingNumber(number: "36.751")
        calculator.startOperation()
        XCTAssert(calculator.textScreen == "550 + 39 / 36.751 = 551.0612")
    }
    func testGivenEmptyScreen_WhenAddingNumberAndAttemptingAddingTwoDotsOnSameNumber_ThenDontAllowIt() {
        calculator.addingNumber(number: "221")
        calculator.addDot()
        calculator.addingNumber(number: "25")
        calculator.addDot()
        calculator.addingNumber(number: "2")
        calculator.add(operator: "+")
        calculator.addingNumber(number: "3")
        calculator.startOperation()
        XCTAssert(calculator.textScreen == "221.252 + 3 = 224.252")
    }
    func testGivenErrorStartANewOperation_WhenAddingOperatorAndClearAndAddOperator_ThenEmptyScreen() {
        calculator.textScreen = "Start a new operation"
        calculator.add(operator: "+")
        calculator.add(operator: "x")
        calculator.add(operator: "/")
        calculator.clear()
        calculator.add(operator: "x")
        calculator.add(operator: "+")
        calculator.add(operator: "/")
        XCTAssert(calculator.textScreen == "")
    }
    func testGivenStartedWrittenOperation_WhenWantToAddMoreOrRethriewSubstraction_ThenAddOrRemoveSubstraction() {
        calculator.add(operator: "-")
        calculator.add(operator: "-")
        calculator.addingNumber(number: "6")
        calculator.add(operator: "-")
        calculator.add(operator: "-")
        calculator.add(operator: "-")
        calculator.add(operator: "+")
        calculator.add(operator: "+")
        calculator.addingNumber(number: "2")
        calculator.startOperation()
        XCTAssert(calculator.textScreen == "-6 + 2 = -4.0")
    }
    func testGivenEmptyScreen_WhenStartOperation_ThenNothingHappen() {
        calculator.startOperation()
        XCTAssert(calculator.textScreen == "")
    }
    func testGivenOperationImcomplete_WhenStartOperation_ThenAlertUINotFinishingByNumber() {
        expectation(forNotification: NSNotification.Name(rawValue: "alertNotFinishingByNumber"),
                    object: nil, handler: nil)
        calculator.textScreen = "2 x"
        calculator.startOperation()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    func testGivenError_WhenStartingANewOperation_ThenClearTextScreenAndContinue() {
        calculator.textScreen = "2 / 0"
        calculator.startOperation()
        calculator.add(operator: "/")
        calculator.addingNumber(number: "4")
        calculator.add(operator: "+")
        calculator.addDot()
        calculator.addingNumber(number: "3")
        calculator.startOperation()
        print(calculator.textScreen)
        XCTAssert(calculator.textScreen == "4 + 0.3 = 4.3")
    }
}
