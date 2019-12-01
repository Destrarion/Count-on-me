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

    func testGivenOperation_WhenAddingSubstractionAndNumber_ThenAddNegativeNumber() {
        calculator.textScreen = "2 x "
        calculator.add(operator: "-")
        calculator.add(number: "1")
        XCTAssert(calculator.textScreen == "2 x -1")
    }
    func testGivenOperation_WhenStartOperation_ThenNotificationUpdateScreen() {
        expectation(forNotification: NSNotification.Name(rawValue: "updateScreen"), object: nil, handler: nil)
        calculator.textScreen = "2 + 5"
        calculator.startOperation()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    func testGivenCalculDividedByZero_WhenStartOperation_ThenAlertUIError() {
        expectation(forNotification: NSNotification.Name(rawValue: "errorDivideByZero"), object: nil, handler: nil)
        calculator.textScreen = "2 / 0"
        calculator.startOperation()
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssert(calculator.textScreen == "Start a new operation")
    }
    func testGivenEmptyCalcul_WhenAddingOperator_ThenReplaceNegativeAndSubstractionNumber() {
        calculator.textScreen = "550 + 39 - -"
        calculator.add(operator: "/")
        XCTAssert(calculator.textScreen == "550 + 39 / ")
    }
    func testGivenEmptyScreen_WhenAddingNumberAndAttemptingAddingTwoDotsOnSameNumber_ThenDontAllowIt() {
        calculator.textScreen = "221.25"
        calculator.addDot()
        calculator.add(number: "2")
        XCTAssert(calculator.textScreen == "221.252")
    }
    func testGivenEmptyScreen_WhenAddingOperatorElseThanSubstraction_ThenStillEmptyScreen() {
        calculator.textScreen = ""
        calculator.add(operator: "+")
        calculator.add(operator: "x")
        calculator.add(operator: "/")
        XCTAssert(calculator.textScreen == "")
    }
    func testGivenStartedWrittenOperationWithTwoSymbolNegative_WhenAddingSymbolAddition_ThenRemoveSubstractionSymbol() {
        calculator.textScreen = " 6 - -"
        calculator.add(operator: "+")
        XCTAssert(calculator.textScreen == " 6 - ")
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
        calculator.textScreen = "Start a new operation"
        calculator.add(number: "2")
        calculator.add(operator: "+")
        calculator.add(number: "4")
        XCTAssert(calculator.textScreen == "2 + 4")
    }
    func testGivenError_WhenAddSubstraction_ThenClearAndAddNegativeSymbol() {
        calculator.textScreen = "Start a new operation"
        calculator.add(operator: "-")
        XCTAssert(calculator.textScreen == "-")
    }
    func testGivenNegativeSymbolOnly_WhenAddSubstraction_ThenDoNotAddEitherSubstractionOrNegativeSymbol() {
        calculator.textScreen = "-"
        calculator.add(operator: "-")
        XCTAssert(calculator.textScreen == "-")
    }
    func testGivenSubstractionAndNegativeNumber_WhenAddSubstraction_ThenDoNotAddSubstractionOrNegativeSymbol() {
        calculator.textScreen = "2 - -"
        calculator.add(operator: "-")
        XCTAssert(calculator.textScreen == "2 - -")
    }
    func testGivenOperationWithResult_WhenAddingSubstractionAfterResult_ThenTextScreenGotResultAndSubstraction() {
        calculator.textScreen = "2 + 3"
        calculator.startOperation()
        calculator.add(operator: "-")
        XCTAssert(calculator.textScreen == "5.0 - ")
    }
    func testGivenEmptyScreen_WhenAddingDot_ThenAddZeroAndDot() {
        calculator.addDot()
        XCTAssert(calculator.textScreen == "0.")
    }
    func testGivenOperationWithLastTextAsOperator_WhenAddDot_ThenAddZeroAndDot() {
        calculator.textScreen = "2 x "
        calculator.addDot()
        XCTAssert(calculator.textScreen == "2 x 0.")
    }
    func testGivenCorrectOperation_WhenPressingDoubleTimeStartOperation_ThenDontDoOperationTwice() {
        calculator.textScreen = "2 + 3"
        calculator.startOperation()
        calculator.startOperation()
        XCTAssert(calculator.textScreen == "2 + 3 = 5.0")
    }
    func testGivenOperationWithNegativeSymbol_WhenAddAddition_ThenRemoveNegativeSymbol() {
        calculator.textScreen = "-"
        calculator.add(operator: "+")
        XCTAssert(calculator.textScreen == "")
    }
    func testGivenNumberEndedByDot_WhenAddDot_ThenDoNotAddDot() {
        calculator.textScreen = "2."
        calculator.addDot()
        XCTAssert(calculator.textScreen == "2.")
    }
    func testGivenOperationEndedByOperator_WhenAddDifferentOperatorThanTheLastOperatorOfTextScreen_ThenReplaceIt() {
        calculator.textScreen = "2 x "
        calculator.add(operator: "+")
        XCTAssert(calculator.textScreen == "2 + ")
    }
    func testGivenOperationWithLastOperator_WhenAddByMultiplicationOperator_ThenReplaceLastOperatorByMultiplcation() {
        calculator.textScreen = "2 + "
        calculator.add(operator: "x")
        XCTAssert(calculator.textScreen == "2 x ")
    }
}
