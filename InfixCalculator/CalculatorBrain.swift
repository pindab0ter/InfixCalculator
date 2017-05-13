import Foundation

struct CalculatorBrain {

    private var accumulator: (value: Double?, description: String) = (nil, "")

    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String, Precedence)
        case equals
    }

    private enum Precedence: Int {
        case min = 0, max
    }

    // @formatter:off
    private var operation: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation({ sqrt($0) }, { "√(\($0))" }),
        "cos": Operation.unaryOperation({ cos($0)}, { "cos\($0)" }),
        // "⁺/₋": Operation.unaryOperation { -$0 },
        "×": Operation.binaryOperation({ $0 * $1 }, { "\($0) × \($1)" }, Precedence.max),
        "÷": Operation.binaryOperation({ $0 / $1 }, { "\($0) ÷ \($1)" }, Precedence.max),
        "+": Operation.binaryOperation({ $0 + $1 }, { "\($0) + \($1)" }, Precedence.min),
        "−": Operation.binaryOperation({ $0 - $1 }, { "\($0) − \($1)" }, Precedence.min),
        "=": Operation.equals
    ]
    // @formatter:on

    mutating func performOperation(_ symbol: String) {
        if let operation = operation[symbol] {
            switch operation {
            case .constant(let value):
                accumulator.value = value
                accumulator.description = symbol
            case .unaryOperation(let function, let description):
                if (accumulator.value != nil) {
                    let result = function(accumulator.value!)
                    let description = description(accumulator.description)
                    accumulator.value = result
                    accumulator.description = description
                }
            case .binaryOperation(let function, let description, let precedence):
                if accumulator.value != nil {
                    pendingBinaryOperation = PendingBinaryOperation(firstOperand: accumulator.value!, currentDescription: accumulator.description, calculationFunction: function, descriptionFunction: description)
                    accumulator = (nil, "")
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }

    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator.value != nil {
            let result = pendingBinaryOperation!.perform(with: accumulator.value!)
            let description = pendingBinaryOperation!.describe(with: accumulator.description)
            accumulator.value = result
            accumulator.description = "\(description)"
            pendingBinaryOperation = nil
        }
    }

    private var pendingBinaryOperation: PendingBinaryOperation?

    private struct PendingBinaryOperation {
        let firstOperand: Double
        let currentDescription: String
        let calculationFunction: (Double, Double) -> Double
        let descriptionFunction: (String, String) -> String

        func perform(with secondOperand: Double) -> Double {
            return calculationFunction(firstOperand, secondOperand)
        }

        func describe(with secondOperand: String) -> String {
            return descriptionFunction(currentDescription, secondOperand)
        }
    }

    mutating func setOperand(_ operand: Double) {
        accumulator.value = operand
        accumulator.description = operand.display
    }

    mutating func clear() {
        accumulator.value = nil
        accumulator.description = ""
        pendingBinaryOperation = nil
    }

    var result: Double? {
        get {
            if accumulator.value == nil && resultPending {
                return pendingBinaryOperation!.firstOperand
            } else {
                return accumulator.value
            }
        }
    }

    var resultPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }

    var description: String? {
        get {
            if resultPending {
                return pendingBinaryOperation!.describe(with: accumulator.description) + "…"
            } else {
                return accumulator.description + " ="
            }
        }
    }
}
