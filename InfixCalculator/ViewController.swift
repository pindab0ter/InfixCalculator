import UIKit

class ViewController: UIViewController {
    private let memorySymbol = "M"
    
    @IBOutlet weak var mainDisplay: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!

    private var userIsTyping = false
    private var brain = CalculatorBrain()
    private var variables: Dictionary<String, Double> = [:]

    /*
     *  Actions
     */
    
    @IBAction func appendDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            appendSymbol(digit)
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
    
    @IBAction func undo() {
        brain.undo()
    }

    @IBAction func clear(_ sender: UIButton) {
        mainDisplay.text = "0"
        descriptionDisplay.text = " "
        userIsTyping = false
        variables = [:]
        brain.clear()
    }

    @IBAction func setMemory() {
        variables[memorySymbol] = displayValue
        evaluate()
    }

    @IBAction func enterMemory() {
        evaluate()
        appendSymbol(memorySymbol)
        brain.setVariable(memorySymbol)
        userIsTyping = false
    }
    
    /*
     *  Helper functions
     */

    private func appendSymbol(_ symbol: String) {
        guard let text = mainDisplay.text else {
            return
        }
        
        if userIsTyping {
            mainDisplay.text = text + symbol
        } else {
            mainDisplay.text = symbol
            userIsTyping = true
        }
    }
    
    private func evaluate() {
        if let result = brain.evaluate(using: variables).result {
            displayValue = result
        }
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
