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
    func testdaurelien() {
        expectation(forNotification: NSNotification.Name(rawValue: "updateScreen"), object: nil, handler: nil)
        calculator.textScreen = "2 + 5"
        calculator.startOperation()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
