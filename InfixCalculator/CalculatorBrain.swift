import Foundation

struct CalculatorBrain {
    private enum Element {
        case operand(Double)
        case operation(Operation)
        case variable(String)
    }

    private enum Operation {
        case constant(Double, String)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equals
    }

    private enum Precedence: Int {
        case min = 0, max
    }

    private var elements: [Element] = []

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

    mutating func setOperand(_ value: Double) {
        elements.append(.operand(value))
    }

    mutating func setOperand(_ symbol: String) {
        elements.append(.variable(symbol))
    }

    mutating func setOperation(_ symbol: String) {
        let operation = operations[symbol]

        guard operation != nil else {
            return // TODO Throw error
        }

        elements.append(.operation(operation!))
    }

    mutating func clear() {
        elements = []
    }

    struct PendingBinaryOperation {
        let firstOperand: Double
        let currentDescription: String
        let operationFunction: (Double, Double) -> Double
        let descriptionFunction: (String, String) -> String

        func perform(with secondOperand: Double) -> Double {
            return operationFunction(firstOperand, secondOperand)
        }

        func describe(with secondOperand: String) -> String {
            return descriptionFunction(currentDescription, secondOperand)
        }
    }

    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        guard !elements.isEmpty else {
            return (nil, false, "")
        }

        var accumulator: (value: Double?, description: String) = (nil, "")
        var pendingBinaryOperation: PendingBinaryOperation?
        var currentPrecedence = Precedence.max
        var operationPending: Bool {
            return pendingBinaryOperation != nil
        }

        func setOperand(value: Double) {
            accumulator.value = value
            accumulator.description = value.display
            currentPrecedence = Precedence.max
        }

        func setOperand(symbol: String) {
            accumulator.value = variables?[symbol] ?? 0
            accumulator.description = symbol
            currentPrecedence = Precedence.max
        }

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
        
        func performPendingBinaryOperation() {
            guard operationPending else {
                return
            }
            
            if accumulator.value != nil {
                let result = pendingBinaryOperation!.perform(with: accumulator.value!)
                let description = pendingBinaryOperation!.describe(with: accumulator.description)
                
                accumulator = (result, description)
                pendingBinaryOperation = nil
            } // TODO Else?
        }
        }

        for element in elements {
            switch element {
            case .operand(let operand):
                setOperand(value: operand)
            case .operation(let operation):
                setOperation(operation)
            case .variable(let variable):
                setOperand(symbol: variable)
            }
        }
        
        return (
                result: accumulator.value,
                isPending: operationPending,
                description: accumulator.description
        )
    }

    @available(iOS, deprecated, message: "Deprecated by evaluate(using:)")
    var result: Double? {
        get {
            return evaluate().result
        }
    }

    @available(iOS, deprecated, message: "Deprecated by evaluate(using:)")
    var operationPending: Bool {
        get {
            return evaluate().isPending
        }
    }

    @available(iOS, deprecated, message: "Deprecated by evaluate(using:)")
    var description: String {
        get {
            return evaluate().description
        }
    }
}
