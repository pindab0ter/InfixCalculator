import UIKit

class ViewController: UIViewController {
    private let memorySymbol = "M"

    @IBOutlet weak var mainDisplay: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    @IBOutlet weak var memoryDisplay: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    private var userIsTyping = false {
        willSet {
            clearButton.setTitle(newValue ? "C" : "AC", for: .normal)
            backButton.setTitle(newValue ? "←" : "Undo", for: .normal)
        }
    }
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
        updateHistoryDisplay()
    }

    @IBAction func backspaceUndo() {
        if userIsTyping {
            backspace()
        } else {
            undo()
        }
    }

    @IBAction func clear(_ sender: UIButton) {
        displayValue = 0
        if userIsTyping {
            userIsTyping = false
        } else {
            variables = [:]
            brain.clear()
            evaluate()
            updateMemoryDisplay()
            updateHistoryDisplay()
        }
    }

    @IBAction func setMemory() {
        variables[memorySymbol] = displayValue
        evaluate()
        updateMemoryDisplay()
        updateHistoryDisplay()
        userIsTyping = false
    }

    @IBAction func enterMemory() {
        evaluate()
        appendSymbol(memorySymbol)
        brain.setVariable(memorySymbol)
        updateHistoryDisplay()
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

    private func backspace() {
        guard var text = mainDisplay.text, !text.isEmpty else {
            return
        }

        text.removeLast()

        if !text.isEmpty {
            mainDisplay.text = text
        } else {
            displayValue = 0
            userIsTyping = false
        }
    }

    private func undo() {
        brain.undo()
        evaluate()
        updateHistoryDisplay()
    }

    private func evaluate() {
        if let result = brain.evaluate(using: variables).result {
            displayValue = result
        }
    }

    private var displayValue: Double {
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

    private func updateHistoryDisplay() {
        let (_, isPending, description) = brain.evaluate()
        var newDescription: String

        if description == "" {
            newDescription = " "
        } else if isPending {
            newDescription = description + "…"
        } else {
            newDescription = description + " ="
        }

        historyDisplay.text = newDescription
    }

    private func updateMemoryDisplay() {
        if let memory = variables[memorySymbol] {
            memoryDisplay.text = "\(memorySymbol): \(memory.display)"
        } else {
            memoryDisplay.text = ""
        }
    }
}
