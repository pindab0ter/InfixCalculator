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
        let expected: Expectation = (value: 7, description: "7 + ")

        brain.setOperand(7)
        brain.setOperation("+")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7b
    func testPendingOperation() {
        let expected: Expectation = (value: 9, description: "7 + 9")

        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7c
    func testCompletedOperation() {
        let expected: Expectation = (value: 16, description: "7 + 9")

        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7d
    func testBinaryWithinUnaryOperation() {
        let expected: Expectation = (value: 4, description: "√(7 + 9)")

        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")
        brain.setOperation("√")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7e
    func testBinaryWithinUnaryFollowedByBinaryOperation() {
        let expected: Expectation = (value: 6, description: "√(7 + 9) + 2")

        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")
        brain.setOperation("√")
        brain.setOperation("+")
        brain.setOperand(2)
        brain.setOperation("=")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7f
    func testUnaryWithinPendingBinaryOperation() {
        let expected: Expectation = (value: 3, description: "7 + √(9)")

        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("√")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7g
    func testUnaryWithinBinaryOperation() {
        let expected: Expectation = (value: 10, description: "7 + √(9)")

        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("√")
        brain.setOperation("=")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7h
    func testMultipleSequentialBinaryOperations() {
        let expected: Expectation = (value: 25, description: "7 + 9 + 6 + 3")

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

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7i
    func testStartNewDescriptionAfterCompletedOperation() {
        let expected: Expectation = (value: 9, description: "6 + 3")

        brain.setOperand(7)
        brain.setOperation("+")
        brain.setOperand(9)
        brain.setOperation("=")
        brain.setOperation("√")
        brain.setOperand(6)
        brain.setOperation("+")
        brain.setOperand(3)
        brain.setOperation("=")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Task 7j is tested in InfixCalculatorUITests.swift

    // Task 7k
    func testBinaryOperationWithConstant() {
        let expected: Expectation = (value: 12.5663706143592, description: "4 × π")

        brain.setOperand(4)
        brain.setOperation("×")
        brain.setOperation("π")
        brain.setOperation("=")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    // Hint 7
    func testConsecutiveBinaryOperations() {
        let expected: Expectation = (value: 360, description: "6 × 5 × 4 × 3")

        brain.setOperand(6)
        brain.setOperation("×")
        brain.setOperand(5)
        brain.setOperation("×")
        brain.setOperand(4)
        brain.setOperation("×")
        brain.setOperand(3)
        brain.setOperation("=")

        XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
        XCTAssertEqual(expected.description, brain.description)
    }

    /* Order of operations is not required by the assignment and would add an extra layer of complexity
     
     func testHighAfterLowPrecedence() {
     let expected: Expectation = (value: 8, description: "6 + 4 ÷ 2")
     
     brain.setOperand(6)
     brain.setOperation("+")
     brain.setOperand(4)
     brain.performOperation("÷")
     brain.setOperand(2)
     brain.performOperation("=")
     
     XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
     XCTAssertEqual(expected.description, brain.description)
     }
     
     func testHighAfterCompletedLowPrecedence() {
     let expected: Expectation = (value: 5, description: "(6 + 4) ÷ 2")
     
     brain.setOperand(6)
     brain.performOperation("+")
     brain.setOperand(4)
     brain.performOperation("=")
     brain.performOperation("÷")
     brain.setOperand(2)
     brain.performOperation("=")
     
     XCTAssertEqualWithAccuracy(expected.value, brain.result!, accuracy: accuracy)
     XCTAssertEqual(expected.description, brain.description)
     }
     
     */
}
