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
}
