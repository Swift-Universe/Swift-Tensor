# Swift Tensor

###### Tensor.swift

This is a lightweight library written in Swift for working with `Tensor` data. It was designed for simplicity and flexibility. It offers high flexibility in initializing the `Tensor` instance. And it is simple to access the data of `Tensor` instance with Swift's `subscript` feature. Many matrix and vector based functions are also provided to do some important specific operations on the data. 


## Initialization

Creating a `Tensor` instance is pretty simple:

```swift
let vector = Tensor(shape: [1, 4], elements: [1, 2, 3, 4])
var matrix = Tensor(shape: [3, 3], element: 3)
let tensor = Tensor(shape: [2, 2, 2], element: 2)
```

### Flexible Initialization

`Tensor` structure's initializers allow flexibile initialization:

* `init(shape:)`: With this initializer one just have to provide the `shape` and the initializer automatically initializes all the `elements` by placing `0` in every place
* `init(shape:element:)`: You must provide the initializer with the `shape` and a single `element` to initialize the `Tensor` instance by repeating `element` in all places
* `init(shape:elements:)`: This initializer requires the `shape` and a linear array of all the `elements` for the `Tensor` instance
* `init(elements:)`: The initializer requires only an array of `elements`. And the intializer sets the `shape` to number of `elements`


## Accessing Values

Swift offers a powerful feature called `subscript`. This library allows for the basic `subscript` syntax to be used for accessing and modifying the values of the `Tensor` instance. The `Tensor` data is accessed using multiple subscript parameters separated by comma, ranging from 1 dimension to N dimensions, as follows:

```swift
visualize(matrix)

/** Prints
3 3 3
3 3 3
3 3 3
**/

// Modify the `Tensor` values using subscript syntax:

matrix[0, 0] = 1
matrix[1, 1] = 1
matrix[2, 2] = 1

visualize(matrix)

/** Prints
1 3 3
3 1 3
3 3 1
**/
```


## Some Important Methods, Computed Properties

In addition to flexiblity in initialization, the `Tensor` also provides some useful and important methods and properties to manipulate the `Tensor` instances.

### Binary Operators

Some basic binary operators that perform element-wise operations are listed below:

* `+` performs addition on two `Tensor` instances
* `-` performs subtraction on two `Tensor` instances
* `*` performs multiplication on two `Tensor` instances
* `/` performs division between two `Tensor` instances

A simple example on usage of binary operators listed above:

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

**Note**: The `*` operator does element-wise multiplication of `Tensor` instances. For matrix multiplication use `matrixProduct(_:_:)` function.


### Extras

Some important functions and properties to manipulate `Tensor` instance data are listed below:

* `matrixProduct(_:_:)`: It takes two matrix shaped `Tensor` instances as parameters and returns the resulting multiplied matrix `Tensor`
* `visualize(_:)`: It takes one matrix or vector shaped `Tensor` instance and gives its visualization by printing it
* `transpose`: This is a computed property called on the `Tensor` instance to return the transposed `Tensor`


#### Important Notes

* The visualize(_:) function can be helpful in testing the elements' position in the `Tensor` (matrix or vector) by visualizing them
* Note that it can be applied only on a matrix or vector shaped `Tensor` instance but not on more than 3-D `Tensor` because it does not make any sense


## Contribution

Contributions are welcome. Please comply with the existing coding style as it helps in easily understanding the code. For instance, `////` have been used to comment whereas `///` is used for fixing the problems in code.

This project is aimed at growing by adding more features that are important to `Tensor` type of data including matrix and vector type of data also. You may pull a request to add new features or for fixing bugs. 

Better and complete documentation is coming soon.

#### We hope to grow this project into a complete tool for performing insane deep learning tasks!

## Contact 

You may contact me directly at [rahulbhalley@icloud.com](rahulbhalley@icloud.com)
