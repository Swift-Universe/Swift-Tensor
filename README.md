# Swift Tensor

###### About Tensor.swift

This is a lightweight library written in Swift for offering `Tensor` data type. It was designed for simplicity in `Tensor` data manipulation. This library offers high level of flexibility in initializing the `Tensor` instance. And the `subscript` feature of Apple Swift makes it easy to access the data of `Tensor` instance. Many matrix and vector based functions are also provided to do some important specific operations on the data. 


## Initialization

Creating a `Tensor` is simple:

```
var vector = Tensor(shape: [1, 4], elements: [1, 2, 3, 4])
var matrix = Tensor(shape: [3, 3], element: 3)
var tensor = Tensor(shape: [2, 2, 2]: element: 2)
```

### Flexible Initialization

`Tensor` initializers allow for flexibile initialization:
* `init(shape:)`: With this initializer one just have to provide the `shape` of the `Tensor` and leave the `elements` to be initialized by itself by placing `0` in every place of the `Tensor` instance.
* `init(shape:element:)`: Provide the initializer with the `shape` of `Tensor` and provide only a single `element` and the initializer will repeat that `element` in every place of the `Tensor` instance.
* `init(shape:elements:)`: This initializer requires the `shape` of the `Tensor` instance and a linear array of all the `elements` for this `Tensor` instance.
* `init(elements:)`: In this initializer only an array of `elements` is required whereas the `shape` is set to the number of items in the `elements` array.


## Accessing Values

Swift offers a powerful feature called `subscript`. And in this library the basic `subscript` syntax is be used to access and modify the values present inside the `Tensor` instance. The multidimensional data is accessed using multiple subscript parameters separated by comma, ranging from 1 dimension to N dimensions `Tensor`, as follows:

```
visualize(matrix)

/** Prints
3 3 3
3 3 3
3 3 3
**/
```

Modify the `Tensor` values using subscript syntax:

```
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

In addition to flexiblity in initialization, the `Tensor` also provides some useful and important methods and properties to manipulate the `Tensor` instance.

### Basic Binary Operators

Some basic binary operators that perform element-wise operations are listed below:

* `+` performs addition on two `Tensor` instances
* `-` performs subtraction on two `Tensor` instances
* `*` performs multiplication on two `Tensor` instances
* `/` performs division between two `Tensor` instances

**Note**: The `*` operator does element-wise multiplication of `Tensor` instances. For matrix multiplication use `matrixProduct(_:_:)` function.

```
let matrix = Tensor(shape: [4, 4], element: 8)
let anotherMatrix = Tensor(shape: [4, 4], element: 2)

let result = matrix / anotherMatrix
visualize(result)

/** Prints
4 4 4 4 
4 4 4 4 
4 4 4 4 
4 4 4 4
**/
```

### Extras

Some important functions and properties to manipulate `Tensor` instance's data are listed below:

* `matrixProduct(_:_:)`: It takes 2 matrix shaped `Tensor` instances as parameters and returns the resulting multiplied matrix `Tensor`
* `visualize(_:)`: It takes 1 matrix or vector shaped `Tensor` instance and gives its visualization by printing it. It can be helpful in testing the elements' position in the `Tensor` by visualizing it
* `transpose`: This is a computed property called on the `Tensor` instance to return the transposed `Tensor`. Note that it can be applied only on a matrix or vector shaped `Tensor` instance but not on more than 3-D `Tensor` because it does not make any sense


## Contribution

Contributions are welcome. Please maintain integrity with the existing coding style in this project as it helps in easily understanding the code such as `////` have been used to comment whereas `///` is used for fixing the problems in code.

This project is aimed at growing by adding more features that are important to `Tensor` type of data including matrix and vector type of data also. You may pull a request to add new features or for fixing bugs. 

Better and complete documentation is coming soon.

#### We hope to grow this project into a complete tool for performing insane deep learning tasks!

## Contact 

You may contact me directly at [rahulbhalley@icloud.com](rahulbhalley@icloud.com)
