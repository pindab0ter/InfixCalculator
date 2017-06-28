import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainDisplay: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!

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

    @IBAction func appendPeriod() {
        if userIsTyping, let text = mainDisplay.text {
            if !text.contains(".") {
                mainDisplay.text = text + "."
            }
        } else {
            mainDisplay.text = "0."
            userIsTyping = true
        }
    }

    @IBAction func operate(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }

        if let symbol = sender.currentTitle {
            brain.setOperation(symbol)
        }

        if let result = brain.result {
            displayValue = result
        }

        updateDescriptionDisplay()
    }

    @IBAction func clear(_ sender: UIButton) {
        mainDisplay.text = "0"
        descriptionDisplay.text = " "
        userIsTyping = false
        brain.clear()
    }

    var displayValue: Double {
        get {
            if let mainDisplayText = mainDisplay.text, let currentValue = Double(mainDisplayText) {
                return currentValue
            } else {
                return 0.0
            }
        }
        set {
            mainDisplay.text = newValue.display
        }
    }

    func updateDescriptionDisplay() {
        var description = brain.description

        if description == "" {
            description = " "
        } else if brain.operationPending {
            description += "…"
        } else {
            description += " ="
        }

        descriptionDisplay.text = description
    }
}
