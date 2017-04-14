/**
    Project Name - Swift-Tensor
    File Name - Tensor.swift
    Created by Rahul Bhalley on 4/14/2017.
**/


///
/// FIXED: Tensor Must Be Generic
///

////
//// To make `Tensor`'s generic type placeholder, T, initializable for `Array` elements.
////
protocol Initable {
    init()
}
////
//// To implement basic mathematical ops on Generic `Tensor`.
////
protocol BasicMathOps {
    static func + (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
}

////
//// Allowed data types for use in `Tensor`.
////
extension Int: BasicMathOps, Initable {}
extension Float: BasicMathOps, Initable {}
extension Double: BasicMathOps, Initable {}

struct Tensor<T: Initable & BasicMathOps> {
    var elements = [T]()
    var size: Int { return elements.count }
    private var axes = [Int]()
    var shape: [Int] {
        get { return self.axes }
        set {}
    }
    var rank: Int { return shape.count }
    /**
    Overloaded Initializers:
     - init(shape:)            - `zeros` in all places of `Tensor` with `shape`.
     - init(shape:element:)    - repeating `element` in all places of `Tensor` with `shape`.
     - init(shape:elements:)   - `elements` of `Tensor` with `shape`.
     - init(elements:)         - `elements` of 1-D `Tensor` with `shape` = [elements.count]. 
    **/
    init(shape axes: [Int]) {
        self.axes = axes
        var count = 1
        var length: Int {
            for i in shape { count *= i }
            return count
        }
        elements = Array<T>(repeating: T(), count: length)
    }
    init(shape axes: [Int], element: T) {
        self.axes = axes
        var count = 1
        var length: Int {
            for i in shape { count *= i }
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
        Tensor Index Validation Methods:
        - Index Validation
        - Shape Validation
    **/
    func indexIsValid(_ index: Int) -> Bool {
        ////
        //// Index Validation
        ////
        return index >= 0 && index < self.shape[0]
    }
    func shapeIsValid(_ shape: [Int]) -> Bool {
        ////
        //// Shape Validation
        ////
        for i in 0..<shape.count {
            if shape[i] < 0 || shape[i] >= self.shape[i] {
                return false
            }
        }
        return true
    }
    /**
        Subscripts Overloading to Access Tensor Values (Settable, Gettable Computed Properties):
        - 1-D subscript
        - N-D subscript
    **/
    subscript(index: Int) -> T {
        ////
        //// Subscript overloading - 1-D
        ////
        get {
            assert(indexIsValid(index), "Error: Index is not valid.")
            return self.elements[index]
        }
        set {
            assert(indexIsValid(index), "Error: Index is not valid.")
        }
    }
    subscript(shape: Int...) -> T {
        ////
        //// Subscript overloading - N-D
        //// 
        get {
            assert(shapeIsValid(shape), "Error: shape is not valid.")
            //// 
            //// calling the 2-D subscript with row, column for 2D world
            ////
            var indexValue = Double((shape[0] * self.shape[1]) + shape[1])
            ////
            //// calculate 1-D index for N-D world
            ////
            for _ in 0..<shape.count - 2 {
                var newIndexValue: Double = 1
                for j in 0..<self.shape.count - 1 {
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
            assert(shapeIsValid(shape), "Error: shape is not valid.")
            //// 
            //// calling the 2-D subscript with row, column for 2D world
            ////
            var indexValue = Double((shape[0] * self.shape[1]) + shape[1])
            ////
            //// calculate 1-D index for N-D world
            ////
            for _ in 0..<shape.count - 2 {
                var newIndexValue: Double = 1
                for j in 0..<self.shape.count - 1 {
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
        Computed Properties to Compute:
        - Transpose of a vector
        - Transpose of a matrix
    **/
    var transpose: Tensor {
        assert(self.shape.count == 2, "Error: Must be a vector (shape = [1, ?] or [?, 1]) or matrix for transpose.")
        var newShape = [Int]()
        if isVector(self) { 
            newShape = shape.reversed()
            return Tensor(shape: newShape, elements: self.elements)
        } else if isMatrix(self) {
            var transposedMatrix = self
            for row in 0..<self.shape[0] {
                for column in 0..<self.shape[1] {
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
        Swift's Advanced Operators to:
        - Add Tensors
        - Subtract Tensors
        - Multiply Tensors
        - Divide Tensors
    **/
    static func + (lhs: Tensor, rhs: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        if lhs.shape == rhs.shape { //// isMatrix(lhs) && isMatrix(rhs) satisfied here
            for i in 0..<lhs.size {	
                output.append(lhs.elements[i] + rhs.elements[i]) 
            }
            outputTensor = Tensor(shape: lhs.shape, elements: output)	
        } else if isVector(lhs) && isMatrix(rhs) {
            assert(lhs.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<rhs.shape[0] {
                for column in 0..<lhs.shape[1] { // to make sure algorithm's idea is correct.
                    output.append(lhs[0, column] + rhs[row, column])
                }
            }
            outputTensor = Tensor(shape: rhs.shape, elements: output)
        } else if isMatrix(lhs) && isVector(rhs) {
            assert(rhs.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<lhs.shape[0] {
                for column in 0..<rhs.shape[1] { // to make sure algorithm's idea is correct.
                    output.append(lhs[row, column] + rhs[0, column])
                }
            }
            outputTensor = Tensor(shape: lhs.shape, elements: output)
        }
        return outputTensor
    }
    static func - (lhs: Tensor, rhs: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        if lhs.shape == rhs.shape { //// isMatrix(lhs) && isMatrix(rhs) satisfied here
            for i in 0..<lhs.size {	
                output.append(lhs.elements[i] + rhs.elements[i]) 
            }
            outputTensor = Tensor(shape: lhs.shape, elements: output)	
        } else if isVector(lhs) && isMatrix(rhs) {
            assert(lhs.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<rhs.shape[0] {
                for column in 0..<lhs.shape[1] { // to make sure algorithm's idea is correct.
                    output.append(lhs[0, column] + rhs[row, column])
                }
            }
            outputTensor = Tensor(shape: rhs.shape, elements: output)
        } else if isMatrix(lhs) && isVector(rhs) {
            assert(rhs.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<lhs.shape[0] {
                for column in 0..<rhs.shape[1] { // to make sure algorithm's idea is correct.
                    output.append(lhs[row, column] + rhs[0, column])
                }
            }
            outputTensor = Tensor(shape: lhs.shape, elements: output)
        }
        return outputTensor
    }
    static func * (lhs: Tensor, rhs: Tensor) -> Tensor {
        assert(lhs.shape == rhs.shape, "Error: Shape of both tensors must be same.")
        var output = [T]()
        for i in 0..<lhs.size { output.append(lhs.elements[i] * rhs.elements[i]) }
        return Tensor(shape: lhs.shape, elements: output)
    }
    static func / (lhs: Tensor, rhs: Tensor) -> Tensor {
        assert(lhs.shape == rhs.shape, "Error: Shape of both tensors must be same.")
        var output = [T]()
        for i in 0..<lhs.size { output.append(lhs.elements[i] / rhs.elements[i]) }
        return Tensor(shape: lhs.shape, elements: output)
    }
}
/**
    Tensor Type Validation Functions:
    - isMatrix(_:)
    - isVector(_:)
**/
func isMatrix<T: BasicMathOps>(_ tensor: Tensor<T>) -> Bool {
    if tensor.shape.count == 2 && tensor.shape[0] != 1 && tensor.shape[1] != 1 { 
        return true 
    }
    return false
}
func isVector<T: BasicMathOps>(_ tensor: Tensor<T>) -> Bool {
    if tensor.shape[0] == 1 || tensor.shape[1] == 1 { 
        return true 
    } else if tensor.shape[0] == 1 && tensor.shape[1] == 1 {
        return false
    } else {
        return false
    }
}

/**
    Tensor Mathematical Functions:
    - matmul(_:_:) - Matrix Multiplication
**/
///
/// FIX: matrixProduct(_:_:) Must Be Generic
///
func matrixProduct(_ matrixA: Tensor<Double>, _ matrixB: Tensor<Double>) -> Tensor<Double> {
    assert(matrixA.shape.count == 2 && matrixB.shape.count == 2, "Error: Must be a matrix.")
    assert(matrixA.shape[1] == matrixB.shape[0], "Error: Column and row size condition not satisfied.")
    var result = [Double]()
    for row in 0..<matrixA.shape[0] {
        for column in 0..<matrixB.shape[1] {
            var product: Double = 0.0
            for x in 0..<matrixA.shape[1] {
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
    Visualization Helper Functions:
    - visualize(_:) - Prints the Matrix or Vector
**/
func visualize<T>(_ matrix: Tensor<T>) {
    assert(matrix.shape.count == 2, "Only vector (shape = [1, ?] or [?, 1]) or matrix are visualizable.")
    for row in 0..<matrix.shape[0] {
        for column in 0..<matrix.shape[1] {
            print(matrix[row, column], terminator: " ")
        }
        print("")
    }
}
