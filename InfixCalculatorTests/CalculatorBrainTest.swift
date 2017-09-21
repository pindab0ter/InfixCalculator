import XCTest
@testable import InfixCalculator

class CalculatorBrainTest: XCTestCase {
    var brain: CalculatorBrain = CalculatorBrain()
    typealias Expectation = (value: Double, description: String)
    let accuracy: Double = 0.000000000001

    override func setUp() {
        super.setUp()
        brain = CalculatorBrain()
    }

    // Task 7a
    func testMissingOperand() {
        brain.setOperand(7)
        brain.setOperation("+")

        let expected: Expectation = (value: 7, description: "7 + ")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7b
    func testPendingOperation() {
        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)

        let expected: Expectation = (value: 9, description: "7 + 9")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7c
    func testCompletedOperation() {
        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")
        
        let expected: Expectation = (value: 16, description: "7 + 9")
        let actual = brain.evaluate()
        
        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7d
    func testBinaryWithinUnaryOperation() {
        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")
        brain.setOperation("√")

        let expected: Expectation = (value: 4, description: "√(7 + 9)")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7e
    func testBinaryWithinUnaryFollowedByBinaryOperation() {
        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")
        brain.setOperation("√")
        brain.setOperation("+")
        brain.setOperand(2)
        brain.setOperation("=")

        let expected: Expectation = (value: 6, description: "√(7 + 9) + 2")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7f
    func testUnaryWithinPendingBinaryOperation() {
        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("√")
        brain.setOperation("=")

        let expected: Expectation = (value: 10, description: "7 + √(9)")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7g
    func testUnaryWithinBinaryOperation() {
        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("√")
        brain.setOperation("=")

        let expected: Expectation = (value: 10, description: "7 + √(9)")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7h
    func testMultipleSequentialBinaryOperations() {
        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")
        brain.setOperation("+")
        brain.setOperand(6)
        brain.setOperation("=")
        brain.setOperation("+")
        brain.setOperand(3)
        brain.setOperation("=")

        let expected: Expectation = (value: 25, description: "7 + 9 + 6 + 3")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7i
    func testStartNewDescriptionAfterCompletedOperation() {
        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")
        brain.setOperation("√")
        brain.setOperand(6)
        brain.setOperation("+")
        brain.setOperand(3)
        brain.setOperation("=")
        
        let expected: Expectation = (value: 9, description: "6 + 3")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Task 7j is tested in InfixCalculatorUITests.swift

    // Task 7k
    func testBinaryOperationWithConstant() {
        brain.setOperand(4)
        brain.setOperation("×")
        brain.setOperation("π")
        brain.setOperation("=")

        let expected: Expectation = (value: 12.5663706143592, description: "4 × π")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    // Hint 7
    func testConsecutiveBinaryOperations() {
        brain.setOperand(6)
        brain.setOperation("×")
        brain.setOperand(5)
        brain.setOperation("×")
        brain.setOperand(4)
        brain.setOperation("×")
        brain.setOperand(3)
        brain.setOperation("=")

        let expected: Expectation = (value: 360, description: "6 × 5 × 4 × 3")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }

    func testHighAfterLowPrecedence() {
        brain.setOperand(6)
        brain.setOperation("+")
        brain.setOperand(4)
        brain.setOperation("÷")
        brain.setOperand(2)
        brain.setOperation("=")

        let expected: Expectation = (value: 8, description: "6 + 4 ÷ 2")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }
    
// Foregoing this test because it is not required by the assignment
//    func testMipleHighAfterLowPrecedence() {
//        brain.setOperand(6)
//        brain.setOperation("+")
//        brain.setOperand(8)
//        brain.setOperation("÷")
//        brain.setOperand(4)
//        brain.setOperation("÷")
//        brain.setOperand(2)
//        brain.setOperation("=")
//
//        let expected: Expectation = (value: 7, description: "6 + 8 ÷ 4 ÷ 2")
//        let actual = brain.evaluate()
//
//        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
//        XCTAssertEqual(actual.description, expected.description)
//    }

    func testHighAfterCompletedLowPrecedence() {
        brain.setOperand(6)
        brain.setOperation("+")
        brain.setOperand(4)
        brain.setOperation("=")
        brain.setOperation("÷")
        brain.setOperand(2)
        brain.setOperation("=")

        let expected: Expectation = (value: 5, description: "(6 + 4) ÷ 2")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }
    
    func testUnsetVariable() {
        brain.setOperand(9)
        brain.setOperation("+")
        brain.setOperand("M")
        brain.setOperation("=")
        brain.setOperation("√")

        let expected: Expectation = (value: 3, description: "√(9 + M)")
        let actual = brain.evaluate()

        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }
    
    func testSetVariable() {
        let variables: Dictionary<String, Double> = ["M": 7]
    
        brain.setOperand(9)
        brain.setOperation("+")
        brain.setOperand("M")
        brain.setOperation("=")
        brain.setOperation("√")
        
        let expected: Expectation = (value: 4, description: "√(9 + M)")
        let actual = brain.evaluate(using: variables)
        
        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }
    
    func testSetVariableContinued() {
        let variables: Dictionary<String, Double> = ["M": 7]
        
        brain.setOperand(9)
        brain.setOperation("+")
        brain.setOperand("M")
        brain.setOperation("=")
        brain.setOperation("√")
        brain.setOperation("+")
        brain.setOperand(14)
        brain.setOperation("=")

        let expected: Expectation = (value: 18, description: "√(9 + M) + 14")
        let actual = brain.evaluate(using: variables)
        
        XCTAssertEqual(actual.result!, expected.value, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }
}
