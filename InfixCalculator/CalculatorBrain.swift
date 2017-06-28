import Foundation

struct CalculatorBrain {

    private var accumulator: (value: Double?, description: String) = (nil, "")
    private var pendingBinaryOperation: PendingBinaryOperation?

    private enum Operation {
        case constant(Double, String)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equals
    }

    private enum Precedence: Int {
        case min = 0, max
    }

    // @formatter:off
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi, "π"),
        "e": Operation.constant(M_E, "e"),
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

        if let operation = operation[symbol] {
        func setOperation(_ operation: Operation) {
            switch operation {
            case .constant(let value, let description):
                accumulator = (value, description)
            case .unaryOperation(let operation, let description):
                if accumulator.value != nil {
                    accumulator = (operation(accumulator.value!), description(accumulator.description))
                }
            case .binaryOperation(let operationFunction, let descriptionFunction):
                performPendingBinaryOperation()
                if accumulator.value != nil {
                    pendingBinaryOperation = PendingBinaryOperation(
                            firstOperand: accumulator.value!,
                            currentDescription: accumulator.description,
                            operationFunction: operationFunction,
                            descriptionFunction: descriptionFunction
                    )
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
