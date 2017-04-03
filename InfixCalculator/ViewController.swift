import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainDisplay: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    @IBOutlet weak var backspaceUndoButton: BorderedButton!

    private var userIsTyping = false
    private var brain = CalculatorBrain()

    @IBAction func appendDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle, let text = mainDisplay.text {
            if userIsTyping {
                mainDisplay.text = text + digit
            } else {
                mainDisplay.text = digit
                userIsTyping = true
            }
        }
    }

    @IBAction func operate(_ sender: UIButton) {
        if userIsTyping{
            brain.setOperand(displayValue)
            userIsTyping = false
        }

        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }

        if let result = brain.result {
            displayValue = result
        }
    }

    var displayValue: Double {
        get {
            if let mainDisplayText = mainDisplay.text, let newValue = Double(mainDisplayText) {
                return newValue
            } else {
                return 0.0
            }
        }
        set {
            mainDisplay.text = String(newValue)
        }
    }
}