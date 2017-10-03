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
        case binaryOperation((Double, Double) -> Double, (String, String) -> String, Precedence)
        case equals
    }

    private enum Precedence: Int {
        case min = 0, max
    }
    
    private struct PendingBinaryOperation {
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

    private var elements: [Element] = []

    // @formatter:off
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi, "π"),
        "e": Operation.constant(M_E, "e"),
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

    mutating func setOperand(_ value: Double) {
        elements.append(.operand(value))
    }

    mutating func setVariable(_ symbol: String) {
        elements.append(.variable(symbol))
    }

    mutating func setOperation(_ symbol: String) {
        let operation = operations[symbol]

        guard operation != nil else {
            return // TODO Throw error
        }

        elements.append(.operation(operation!))
    }
    
    mutating func undo() {
        // Remove last element from Elements
        // How to deal with "="?
    }

    mutating func clear() {
        elements = []
    }

    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        guard !elements.isEmpty else {
            return (nil, false, "")
        }
        
        var currentPrecedence = Precedence.max
        var pendingBinaryOperations: [PendingBinaryOperation] = []
        var operationPending: Bool {
            return !pendingBinaryOperations.isEmpty
        }
        var accumulator: (value: Double?, description: String) = (nil, "")

        func setOperand(_ value: Double) {
            accumulator.value = value
            accumulator.description = value.display
        }

        func setVariable(_ symbol: String) {
            accumulator.value = variables?[symbol] ?? 0
            accumulator.description = symbol
        }

        func setOperation(_ operation: Operation) {
            switch operation {
            case .constant(let value, let description):
                accumulator = (value, description)
            case .unaryOperation(let operation, let description):
                if accumulator.value != nil {
                    accumulator = (operation(accumulator.value!), description(accumulator.description))
                }
            case .binaryOperation(let operationFunction, let descriptionFunction, let newPrecedence):
                guard accumulator.value != nil else {
                    return
                }
                
                if operationPending, newPrecedence.rawValue > currentPrecedence.rawValue {
                    pendingBinaryOperations.append(
                        PendingBinaryOperation(
                            firstOperand: accumulator.value!,
                            currentDescription: accumulator.description,
                            operationFunction: operationFunction,
                            descriptionFunction: descriptionFunction
                        )
                    )
                } else {
                    performPendingBinaryOperations()
                    
                    if currentPrecedence.rawValue < newPrecedence.rawValue {
                        accumulator.description = "(\(accumulator.description))"
                    }
                    
                    pendingBinaryOperations = [PendingBinaryOperation(
                        firstOperand: accumulator.value!,
                        currentDescription: accumulator.description,
                        operationFunction: operationFunction,
                        descriptionFunction: descriptionFunction
                    )]
                }
                currentPrecedence = newPrecedence
                
            case .equals:
                performPendingBinaryOperations()
            }
        }

        func performPendingBinaryOperations() {
            guard operationPending, accumulator.value != nil else {
                return
            }
            
            for operation in pendingBinaryOperations.reversed() {
                accumulator.value = operation.perform(with: accumulator.value!)
                accumulator.description = operation.describe(with: accumulator.description)
            }
            
            pendingBinaryOperations = []
        }

        func finaliseDescription() {
            guard operationPending else {
                return
            }

            if let lastElement = elements.last {
                switch lastElement {
                case .operand(let operand):
                    accumulator.description = pendingBinaryOperations.last!.describe(with: operand.display)
                case .variable(let symbol):
                    accumulator.description = pendingBinaryOperations.last!.describe(with: symbol)
                default:
                    accumulator.description = pendingBinaryOperations.last!.describe(with: "")
                }
            }
        }

        for element in elements {
            switch element {
            case .operand(let value):
                setOperand(value)
            case .variable(let symbol):
                setVariable(symbol)
            case .operation(let operation):
                setOperation(operation)
            }
        }

        finaliseDescription()

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
