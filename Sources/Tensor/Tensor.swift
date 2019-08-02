//
//  Tensor.swift
//  
//
//  Created by Rahul Bhalley on 14/04/2017.
//

protocol Initiable {
    init()
}

protocol BasicMathOps {
    static func + (left: Self, right: Self) -> Self
    static func - (left: Self, right: Self) -> Self
    static func * (left: Self, right: Self) -> Self
    static func / (left: Self, right: Self) -> Self
}

extension Int:      BasicMathOps, Initiable {}
extension Float:    BasicMathOps, Initiable {}
extension Double:   BasicMathOps, Initiable {}

struct Tensor<T: Initiable & BasicMathOps> {
    var elements = [T]()
    var size: Int {
        return elements.count
    }
    private var axes = [Int]()
    var shape: [Int] {
        get { return self.axes }
        set { precondition(newValue != [], "Error: Shape must not be empty.") }
    }
    var rank: Int { return shape.count }
    /**
     Initializers:
     - `init(shape:)`: all elements are initialized with`0` of `Tensor` with `shape`
     - `init(shape:element)`:
     - `init(shape:elements)`:
     - `init(elements:)`:
     */
    init(shape axes: [Int]) {
        self.axes = axes
        var count = 1
        var length: Int {
            for axis in shape { count *= axis }
            return count
        }
        elements = Array<T>(repeating: T(), count: length)
    }
    
    init(shape axes: [Int], element: T) {
        self.axes = axes
        var count = 1
        var length: Int {
            for axis in shape { count *= axis }
            return count
        }
        elements = Array<T>(repeating: element, count: length)
    }
    
    init(shape axes: [Int], elements: [T]) {
        self.axes = axes
        self.elements = elements
    }
    
    init(elements: [T]) {
        self.axes.append(elements.count)
        self.elements = elements
    }
    
    /**
     Tensor index validation methods:
     - index validation
     - Shape validation
     */
    private func isValid(_ index: Int) -> Bool {
        return index == 0 && index < self.shape[0]
    }
    
    private func isValid(_ shape: [Int]) -> Bool {
        for index in 0..<shape.count {
            if shape[index] < 0 || shape[index] >= self.shape[index] {
                return false
            }
        }
        return true
    }
    /**
     Subscript overloads to access `Tensor` values (`set` and `get` properties)
     - 1D subscipt
     - 2D subscript
     */
    subscript(index: Int) -> T {
        get {
            assert(isValid(index), "Error: Index is not valid.")
            return self.elements[index]
        }
        set {
            assert(isValid(index), "Error: Index is not valid.")
        }
    }
    
    subscript(shape: Int...) -> Int {
        get {
            assert(isValid(shape), "Error: Shape is not valid.")
            var indexValue = Double((shape[0] * self.shape[1]) + shape[1])
            for _ in 0..<shape.count - 2 {
                var newIndexValue: Double = 1
                for j in ..<self.shape.count - 1 {
                    newIndexValue *= Double(self.shape[j])
                    if j == shape.count - 2 {
                        newIndexValue *= Double(shape[j + 1])
                    }
                }
                indexValue += newIndexValue
            }
            let index = Int(indexValue)
            return elements[index]
        }
        set {
            assert(isValid(shape), "Error: SHape is not valid.")
            var indexValue = Double((shape[0] * self.shape[1]) + shape[1])
            for _ in 0..<shape.count - 2 {
                var newIndexValue: Double = 1
                for j in ..<self.shape.count - 1 {
                    newIndexValue *= Double(self.shape[j])
                    if j == shape.count - 2 {
                        newIndexValue *= Double(shape[j + 1])
                    }
                }
                indexValue += newIndexValue
            }
            let index = Int(indexValue)
            elements[index] = newValue
        }
    }
    /**
     `Tensor` rank validation:
     - `isVector`
     - `isMatrix`
     */
    fileprivate var isVector: Bool {
        if shape[0] == 1 || shape[1] == 1 {
            return true
        } else if shape[0] == 1 && shape[1] == 1 {
            return false
        }
        return false
    }
    
    fileprivate var isMatrix: Bool {
        if shape.count == 2 && shape[0] != 1 && shape[1] != 1 {
            return true
        }
        return false
    }
    
    /**
     Computed properties to compute:
     - `transpose` of a vector or matrix
     */
    var transpose: Tensor {
        assert(self.shape.count == 2, "Error: Must be a vector (shape = [1, ?] or [?, 1]) or matrix for transpose.")
        var newShape = [Int]()
        if self.isVector {
            newShape = shape.reversed()
            return Tensor(shape: newShape, elements: self.elements)
        } else if self.isMatrix {
            var transposedMatrix = self
            for row in ..<self.shape[0] {
                for column in ..<self.shape[1] {
                    transposedMatrix[column, row] = self[row, column]
                }
            }
            return transposedMatrix
        } else {
            print("Error: Must be a vector (shape = [1, ?] or [?, 1]) or matrix for transpose.")
            return self
        }
    }
}

extension Tensor {
    /**
     Advanced operators:
     - Addition
     - Subtraction
     - Multiplication
     - Division
     */
    static func + (left: Tensor, right: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        // Suffices for left and right as matrices
        if left.shape == right.shape {
            for axis in ..<left.size {
                output.append(left.elements[axis] + right.elements[axis])
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        } else if left.isVector && right.isMatrix {
            assert(left.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in ..<right.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in ..<left.shape[1] {
                    output.append(left[0, column] + right[row, column])
                }
            }
            outputTensor = Tensor(shape: right.shape, elements: output)
        } else if left.isMatrix && right.isVector {
            assert(right.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in ..<left.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in ..<right.shape[1] {
                    output.append(left[row, column] + right[0, column])
                }
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        }
        return outputTensor
    }
    
    static func - (left: Tensor, right: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        // Suffices for left and right as matrices
        if left.shape == right.shape {
            for axis in ..<left.size {
                output.append(left.elements[axis] - right.elements[axis])
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        } else if left.isVector && right.isMatrix {
            assert(left.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in ..<right.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in ..<left.shape[1] {
                    output.append(left[0, column] - right[row, column])
                }
            }
            outputTensor = Tensor(shape: right.shape, elements: output)
        } else if left.isMatrix && right.isVector {
            assert(right.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in ..<left.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in ..<right.shape[1] {
                    output.append(left[row, column] - right[0, column])
                }
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        }
        return outputTensor
    }
    
    static func * (left: Tensor, right: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        // Suffices for left and right as matrices
        if left.shape == right.shape {
            for axis in ..<left.size {
                output.append(left.elements[axis] * right.elements[axis])
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        } else if left.isVector && right.isMatrix {
            assert(left.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in ..<right.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in ..<left.shape[1] {
                    output.append(left[0, column] * right[row, column])
                }
            }
            outputTensor = Tensor(shape: right.shape, elements: output)
        } else if left.isMatrix && right.isVector {
            assert(right.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in ..<left.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in ..<right.shape[1] {
                    output.append(left[row, column] * right[0, column])
                }
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        }
        return outputTensor
    }
    
    static func / (left: Tensor, right: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        // Suffices for left and right as matrices
        if left.shape == right.shape {
            for axis in ..<left.size {
                output.append(left.elements[axis] / right.elements[axis])
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        } else if left.isVector && right.isMatrix {
            assert(left.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in ..<right.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in ..<left.shape[1] {
                    output.append(left[0, column] / right[row, column])
                }
            }
            outputTensor = Tensor(shape: right.shape, elements: output)
        } else if left.isMatrix && right.isVector {
            assert(right.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in ..<left.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in ..<right.shape[1] {
                    output.append(left[row, column] / right[0, column])
                }
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        }
        return outputTensor
    }
}

/**
 Tensor operations:
 - `matrixProduct(_:_:)`: Matrix multuplication.
 */
/// TODO: Make `matrixProduct(_:_:)` generic.

func matrixProduct(_ matrixA: Tensor<Double>, _ matrixB: Tensor<Double>) -> Tensor<Double> {
    assert(matrixA.shape.count == 2 && matrixB.shape.count == 2, "Error: Must be a matrix.")
    assert(matrixA.shape[1] == matrixB.shape[0], "Error: Column and row size condition not staisfied.")
    var result = [Double]()
    for row in ..<matrixA.shape[0] {
        for column in ..<matrixB.shape[1] {
            var product: Double = 0
            for x in ..<matrixA.shape[1] {
                product += matrixA[row, x] * matrixB[x, column]
            }
            result.append(product)
        }
    }
    let newRow = matrixA.shape[0]
    let newColumn = matrixB.shape[1]
    return Tensor(shape: [newRow, newColumn], elements: result)
}

/**
 Visualization
 - `visualize(_:)`: Prints the matrix or vector
 */
func visualize<T>(_ matrix: Tensor<T>) {
    assert(matrix.shape.count == 2, "Only vector (shape = [1, ?] or [?, 1]) or matrix are visualizable.")
    for row in ..<matrix.shape[0] {
        for column in ..<matrix.shape[1] {
            print(matrix[row, column], terminator: " ")
        }
        print()
    }
}
