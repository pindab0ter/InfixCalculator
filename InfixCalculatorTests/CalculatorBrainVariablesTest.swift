import XCTest
@testable import InfixCalculator

class CalculatorBrainVariablesTest: XCTestCase {
    var brain: CalculatorBrain = CalculatorBrain()
    typealias Expectation = (value: Double, description: String)
    let accuracy: Double = 0.000000000001

    override func setUp() {
        super.setUp()
        brain = CalculatorBrain()
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
