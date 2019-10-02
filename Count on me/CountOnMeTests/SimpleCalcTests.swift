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
    func testGivenScreenShowNothing_WhenAdding1OnTextScreen_ThenTextScreenShow1() {
        let addOne = 1
        calculator.textScreen.append("\(addOne)")
        XCTAssert(calculator.textScreen == "1")
    }
    func testGiven3Elements_WhenDecomposingIntoTable_ThenOperatorIsOnPosition2() {
        calculator.textScreen = "2 + 5"
        var textScreenDecomposate = calculator.elements
        XCTAssert(textScreenDecomposate[1] == "+")
    }
    func testGiven1ElementTextScreen_WhenExpressionHaveEnoughElement_ThenReturnTrue() {
        calculator.textScreen = "22  + 4"
        XCTAssert(calculator.expressionHaveEnoughElement)
    }
    func testGivenThreePlusTwoInTextScreen_WhenExpressionIsCorrect_ThenExpressionIsCorrectIsTrue() {
        calculator.textScreen = "3 + 2"
        XCTAssert(calculator.expressionIsCorrect == true)
    }
    func testGiven3Elements_WhenCalculatorHaveEnoughtElements_ThenHaveEnoughtElementsIsTrue() {
        calculator.textScreen = "525 - 434"
        XCTAssert(calculator.expressionHaveEnoughElement == true)
    }
    func testGivenEmptyTextScreen_WhenAddingNumberAndOperation_ThenWrittenInTextScreen() {
        calculator.textScreen = ""
        calculator.textScreen.append("12")
        XCTAssert(calculator.canAddOperator == true)
        calculator.addingSubstraction()
        calculator.textScreen.append("3")
        calculator.addingAddition()
        calculator.textScreen.append("4")
        calculator.addingMultiplication()
        calculator.textScreen.append("2")
        calculator.addingDivision()
        calculator.textScreen.append("2")
    }
    func testGivenCalcul_WhenStartingOperationAndHaveResult_ThenExpressionHaveResultIsTrue() {
        calculator.textScreen = "56 - 24"
        calculator.startOperation()
    }
}
