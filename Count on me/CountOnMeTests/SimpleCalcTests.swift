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
        calculator.addingMultiplication()
        calculator.addingSubstraction()
        calculator.addDot()
        calculator.addingNumber(number: "1")
        calculator.startOperation()
        XCTAssert(calculator.textScreen == "2 x -0.1 = -0.2")
    }
    func testNotificationUpdateScreen() {
        expectation(forNotification: NSNotification.Name(rawValue: "updateScreen"), object: nil, handler: nil)
        calculator.textScreen = "2 + 5"
        calculator.startOperation()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    func testGivenCalculDividedByZero_WhenStartOperation_ThenAlertUIError() {
        expectation(forNotification: NSNotification.Name(rawValue: "updateScreen"), object: nil, handler: nil)
        calculator.addDot()
        calculator.addingDivision()
        calculator.addingNumber(number: "0")
        calculator.startOperation()
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssert(calculator.textScreen == "Start a new operation")
    }
    func testGivenEmptyCalcul_WhenAddingAdditionAfterSubstraction_ThenRemoveNegativeAndSubstractionNumber() {
        calculator.addingNumber(number: "550")
        calculator.addingAddition()
        calculator.addingNumber(number: "39")
        calculator.addingSubstraction()
        calculator.addingSubstraction()
        calculator.addingDivision()
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
        calculator.addingAddition()
        calculator.addingNumber(number: "3")
        calculator.startOperation()
        XCTAssert(calculator.textScreen == "221.252 + 3 = 224.252")
    }
    func testGivenErrorStartANewOperation_WhenAddingMultiplicationAndClearAndAddMultiplication_ThenEmptyScreen() {
        calculator.textScreen = "Start a new operation"
        calculator.addingMultiplication()
        calculator.clear()
        calculator.addingMultiplication()
        XCTAssert(calculator.textScreen == "")
    }
}
