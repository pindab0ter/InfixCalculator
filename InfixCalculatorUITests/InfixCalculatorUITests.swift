import XCTest

class InfixCalculatorUITests: XCTestCase {

    var app: XCUIApplication = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // Task 7j
    func testUnaryOperation() {
        app.buttons["5"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["7"].tap()
        app.buttons["3"].tap()

        let expectedResult = app.staticTexts["73"]
        let expectedHistory = app.staticTexts["5 + 6 ="]

        XCTAssert(expectedResult.exists, "Main display should show entered value")
        XCTAssert(expectedHistory.exists, "Description display should show most recent state")
    }
}
