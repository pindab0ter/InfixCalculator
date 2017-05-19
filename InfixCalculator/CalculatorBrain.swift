import Foundation

struct CalculatorBrain {

    private var accumulator: (value: Double?, description: String) = (nil, "")
    private var pendingBinaryOperation: PendingBinaryOperation?

    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
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
        "×": Operation.binaryOperation({ $0 * $1 }, { "\($0) × \($1)" }),
        "÷": Operation.binaryOperation({ $0 / $1 }, { "\($0) ÷ \($1)" }),
        "+": Operation.binaryOperation({ $0 + $1 }, { "\($0) + \($1)" }),
        "−": Operation.binaryOperation({ $0 - $1 }, { "\($0) − \($1)" }),
        "=": Operation.equals
    ]
    // @formatter:on

    mutating func setOperand(_ operand: Double) {
        if !operationPending {
            accumulator.description = ""
        }

        accumulator.value = operand
        accumulator.description += operand.display
    }

    mutating func performOperation(_ symbol: String) {
        if let operation = operation[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = (value, symbol)
            case .unaryOperation(let operation, let description):
                if accumulator.value != nil {
                    accumulator = (operation(accumulator.value!), description(accumulator.description))
                }
            case .binaryOperation(let operation, let description):
                performPendingBinaryOperation()
                if accumulator.value != nil {
                    pendingBinaryOperation = PendingBinaryOperation(firstOperand: accumulator.value!, currentDescription: accumulator.description, operation: operation, description: description)
                    accumulator = (nil, "")
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }

    private mutating func performPendingBinaryOperation() {
        if operationPending && accumulator.value != nil {
            let result = pendingBinaryOperation!.perform(with: accumulator.value!)
            let description = pendingBinaryOperation!.describe(with: accumulator.description)

            accumulator = (result, "\(description)")
            pendingBinaryOperation = nil
        }
    }

    private struct PendingBinaryOperation {
        let firstOperand: Double
        let currentDescription: String
        let operation: (Double, Double) -> Double
        let description: (String, String) -> String

        func perform(with secondOperand: Double) -> Double {
            return operation(firstOperand, secondOperand)
        }

        func describe(with secondOperand: String) -> String {
            return description(currentDescription, secondOperand)
        }
    }

    mutating func clear() {
        accumulator = (0, "")
        pendingBinaryOperation = nil
    }

    var result: Double? {
        get {
            if accumulator.value == nil && operationPending {
                return pendingBinaryOperation!.firstOperand
            } else {
                return accumulator.value
            }
        }
    }

    var operationPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }

    var description: String {
        get {
            if operationPending {
                return pendingBinaryOperation!.describe(with: accumulator.description)
            } else {
                return accumulator.description
            }
        }
    }
}
