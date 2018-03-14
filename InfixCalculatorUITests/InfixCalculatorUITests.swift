import XCTest

class InfixCalculatorUITests: XCTestCase {

    private typealias Status = (result: Double, description: String)
    var app: XCUIApplication = XCUIApplication()
    let accuracy = 0.000001

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // Task 7j
    func testGenericOperations() {
        var expected: Status = (0, "")
        var actual: Status = (0, "")

        // Task 7a
        app.buttons["7"].tap()
        app.buttons["+"].tap()

        expected = (7, "7 + …")
        actual = (Double(app.staticTexts["resultDisplay"].label)!, app.staticTexts["historyDisplay"].label)

        XCTAssertEqual(actual.result, expected.result, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)

        // Task 7b
        app.buttons["9"].tap()

        expected = (9, "7 + …")
        actual = (Double(app.staticTexts["resultDisplay"].label)!, app.staticTexts["historyDisplay"].label)

        XCTAssertEqual(actual.result, expected.result, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)

        // Task 7c
        app.buttons["="].tap()

        expected = (16, "7 + 9 =")
        actual = (Double(app.staticTexts["resultDisplay"].label)!, app.staticTexts["historyDisplay"].label)

        XCTAssertEqual(actual.result, expected.result, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)

        // Task 7d
        XCUIDevice.shared.orientation = .landscapeLeft
        app.buttons["√"].tap()
        XCUIDevice.shared.orientation = .portrait

        expected = (4, "√(7 + 9) =")
        actual = (Double(app.staticTexts["resultDisplay"].label)!, app.staticTexts["historyDisplay"].label)

        XCTAssertEqual(actual.result, expected.result, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)

        // Task 7e
        app.buttons["+"].tap()
        app.buttons["2"].tap()
        app.buttons["="].tap()

        expected = (6, "√(7 + 9) + 2 =")
        actual = (Double(app.staticTexts["resultDisplay"].label)!, app.staticTexts["historyDisplay"].label)

        XCTAssertEqual(actual.result, expected.result, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)

        app.buttons["AC"].tap()

        expected = (0, " ")
        actual = (Double(app.staticTexts["resultDisplay"].label)!, app.staticTexts["historyDisplay"].label)

        XCTAssertEqual(actual.result, expected.result, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)

        // Task 7j
        app.buttons["5"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["7"].tap()
        app.buttons["3"].tap()

        expected = (73, "5 + 6 =")
        actual = (Double(app.staticTexts["resultDisplay"].label)!, app.staticTexts["historyDisplay"].label)

        XCTAssertEqual(actual.result, expected.result, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)

        app.buttons["C"].tap()
        app.buttons["AC"].tap()
        
        // Task 7k
        app.buttons["4"].tap()
        app.buttons["×"].tap()
        XCUIDevice.shared.orientation = .landscapeLeft
        app.buttons["π"].tap()
        XCUIDevice.shared.orientation = .portrait
        app.buttons["="].tap()

        expected = (12.5663706143592, "4 × π =")
        actual = (Double(app.staticTexts["resultDisplay"].label)!, app.staticTexts["historyDisplay"].label)
        
        XCTAssertEqual(actual.result, expected.result, accuracy: accuracy)
        XCTAssertEqual(actual.description, expected.description)
    }
}
