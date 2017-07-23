# Swift Tensor

###### Tensor.swift

This is a super lightweight library written in Swift for working with `Tensor` data type. It offers simplicity and flexibility in initializing and manipulating the `Tensor` instance. Swift's `subscript` feature is used to access the data of `Tensor` instance. Many specific functions are also provided to do important matrix and vector-based operations.

Moreover, `Tensor` automatically infers its type from the type of `elements` you provide to it. In addition to its generic nature, it is intentionally restricted to work with `Int`, `Float`, or `Double` data types because it is a computational library. 



## Initialization

Creating a `Tensor` instance is pretty simple:

```swift
let vector = Tensor(shape: [1, 4], elements: [1, 2, 3, 4])  // 1-D Tensor, shape 1 x 4
var matrix = Tensor(shape: [3, 3], element: 3)              // 2-D Tensor, shape 3 x 3
let tensor = Tensor(shape: [3, 3, 3, 4], element: 2)        // 4-D Tensor, shape 3 x 3 x 3 x 4
```

### Initialization Flexibility

`Tensor` data type's initializers allow flexible initialization:

* `init(shape:)`: Must provide the `shape` and `Tensor` instance is automatically initialized with `0` in every place
```swift
var matrix = Tensor<Int>(shape: [3, 3])

visualize(matrix)
/** Prints
0 0 0 
0 0 0 
0 0 0 
**/
```
* `init(shape:element:)`: Must provide the `shape` and an `element` to initialize the `Tensor` instance with `element` in all places
```swift
var identityMatrix = Tensor(shape: [3, 3], element: 1)

visualize(identityMatrix)
/** Prints
1 1 1 
1 1 1 
1 1 1
**/
```
* `init(shape:elements:)`: Must provide the `shape` and the `elements` array to initialize `Tensor` with `shape` and `elements` in their respective places
```swift
var linear = Tensor(shape: [3], elements: [5, 9, 1])
```
* `init(elements:)`: Must provide the `elements` and the `shape` is automatically set equal to the number of `elements`
```swift
var anotherLinear = Tensor(elements: [1, 2, 3, 4, 5, 6, 7])
```

## Accessing Values

`Tensor` uses Swift's powerful feature called `subscript` for accessing and modifying the values of the `Tensor` instances. To access data at a specific position in N dimensional `Tensor`, N `subscript` parameters are provided as follows:

```swift
visualize(matrix)
/** Prints
3 3 3
3 3 3
3 3 3
**/

// Modify the matrix's values using subscript syntax:
for i in 0..<min(matrix.shape[0], matrix.shape[1]) {
    matrix[i, i] = 1
}

visualize(matrix)
/** Prints
1 3 3
3 1 3
3 3 1
**/
```


## Some Powerful Methods, Computed Properties

In addition to flexibility in initialization, the `Tensor` also provides some useful and powerful methods and properties to manipulate the `Tensor` instances.

### Binary Operators

The basic binary operators that perform element-wise operations are listed below:

* `+` performs addition on two `Tensor` instances
* `-` performs subtraction on two `Tensor` instances
* `*` performs multiplication on two `Tensor` instances
* `/` performs division between two `Tensor` instances

A simple example on the usage of binary operators listed above:

```swift
let matrixOne = Tensor(shape: [4, 4], element: 8)
let matrixTwo = Tensor(shape: [4, 4], element: 2)
let result = matrixOne / matrixTwo

visualize(result)
/** Prints
4 4 4 4 
4 4 4 4 
4 4 4 4 
4 4 4 4
**/
```

**Note**: The `*` operator does element-wise multiplication of `Tensor` instances. To perform matrix multiplication, use `matrixProduct(_:_:)` function.


### Additional Functions, Properties

Extra functions and properties to manipulate `Tensor` instance data are listed below:

* `matrixProduct(_:_:)`: It takes two matrix shaped `Tensor` instances as parameters and returns the resulting multiplied matrix `Tensor`
* `visualize(_:)`: It takes one matrix or vector shaped `Tensor` instance and gives its visualization by printing it
* `transpose`: This is a computed property called on the `Tensor` instance to return the transposed `Tensor`


#### Notes

* `visualize(_:)` function can be helpful in examining the position of `elements` in the `Tensor` instance (matrix or vector) by visualizing them
* `transpose` can be applied on a matrix or vector shaped `Tensor` instance only


## Contribution

We welcome the contributions. You may pull a request to add important features to `Tensor` data type or for fixing bugs. Please comply with the existing coding style as it helps in easily understanding the code. For instance,
* `////` have been used for comments
* `///` is used as a TODO comment. For instance, `/// TODO: Make matrixProduct(_:_:) generic`

This project aims to grow with more operations and performance optimizations which are important to `Tensor` data calculations including any other data type representable by it. 

## Contact 

You may contact me directly at `rahulbhalley[at]icloud[dot]com`
