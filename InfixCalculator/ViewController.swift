import UIKit

class ViewController: UIViewController {
    private let memorySymbol = "M"
    
    @IBOutlet weak var mainDisplay: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!

    private var userIsTyping = false
    private var brain = CalculatorBrain()
    private var variables: Dictionary<String, Double> = [:]

    @IBAction func appendDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            appendSymbol(digit)
        }
    }
    
    private func appendSymbol(_ symbol: String) {
        if let text = mainDisplay.text {
            if userIsTyping {
                mainDisplay.text = text + symbol
            } else {
                mainDisplay.text = symbol
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

        evaluate()
        updateDescriptionDisplay()
    }

    @IBAction func clear(_ sender: UIButton) {
        mainDisplay.text = "0"
        descriptionDisplay.text = " "
        userIsTyping = false
        brain.clear()
    }

    @IBAction func setMemory() {
        variables[memorySymbol] = displayValue
    }

    @IBAction func enterMemory() {
        evaluate()
        appendSymbol(memorySymbol)
        brain.setOperand(memorySymbol)
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

    private func evaluate() {
        if let result = brain.evaluate(using: variables).result {
            displayValue = result
        }
    }

    func updateDescriptionDisplay() {
        let (_, isPending, description) = brain.evaluate()
        var newDescription: String
    
        if description == "" {
            newDescription = " "
        } else if isPending {
            newDescription = description + "…"
        } else {
            newDescription = description + " ="
        }

        descriptionDisplay.text = newDescription
    }
}
