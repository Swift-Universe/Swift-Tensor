# Swift Tensor

###### Tensor.swift

This is a lightweight library written in Swift for offering `Tensor` data type. It was designed for simplicity in `Tensor` data manipulation. This library offers high level of flexibility in initializing the `Tensor` instance. And the `subscript` feature of Apple Swift makes it easy to access the data of `Tensor` instance. 

Many matrix and vector based functions are provided to do some important specific operations on the data. 


## Initialization

Creating a `Tensor` is simple

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

Swift offers a powerful feature called `subscript`. And in this library the basic `subscript` syntax is be used to access and modify the values present inside the `Tensor` instance. The multidimensional data is accessed using multiple subscript parameters separated by comma, ranging from 1-D to N-D `Tensor`, as follows:

```
visualize(matrix)

/* Prints

3 3 3
3 3 3
3 3 3
*/
```

Modify the `Tensor` values using subscript syntax.

```
matrix[0, 0] = 1
matrix[1, 1] = 1
matrix[2, 2] = 1

visualize(matrix)

/* Prints

1 3 3
3 1 3
3 3 1
*/
```


## Some Important Methods, Computed Properties

In addition to flexiblity in initialization, the `Tensor` also provides some useful and important methods and properties to manipulate the `Tensor` instance.

### Basic Binary Operators

Some basic binary operators that perform element-wise operations are listed below:
* `+`: It performs addition on 2 `Tensor` instances
* `-`: It performs subtraction on 2 `Tensor` instances
* `*`: It performs multiplication on 2 `Tensor` instances.
* `/`: It performs division between 2 `Tensor` instances

Note that `*` operator does element-wise multiplication of `Tensor` instances. For matrix multiplication use `matrixProduct(_:_:)` function.

```
let matrix = Tensor(shape: [2, 2], element: 4)
let anotherMatrix = Tensor(shape: [2, 2], element: 2)

let sum = matrix + anotherMatrix
let product = matrix * anotherMatrix
let difference = matrix - anotherMatrix
let dividedResult = matrix / anotherMatrix

let results = [sum, product, difference, dividedResult]
for result in results {
    visualize(result)
    print("")
}

/* Prints

6 6 
6 6 

8 8 
8 8 

2 2 
2 2 

2 2 
2 2
*/
```

### Functions

* `matrixProduct(_:_:)`: It takes 2 matrix shaped `Tensor` instances as parameters and returns the resulting multiplied matrix `Tensor`.
* `visualize(_:)`: It takes 1 matrix or vector shaped `Tensor` instance and gives its visualization by printing it. It can be helpful in testing the elements' position in the `Tensor` by visualizing it.
* `transpose`: This is a computed property called on the `Tensor` instance to return the transposed `Tensor`. Note that it can be applied only on a matrix or vector shaped `Tensor` instance but not on more than 3-D `Tensor` because it does not make any sense.
