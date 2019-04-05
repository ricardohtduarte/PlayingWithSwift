import UIKit

struct MyStruct {
    var number1Struct = 1
    var number2Struct = 2
}

class MyClass {
    var number1Class = 3
    var number2Class = 4
}

var myStruct = MyStruct()
let myClass = MyClass()

// struct will maintain the value despite the fact of being a constant object
// class let changing the value
myStruct.number1Struct = 5
myClass.number1Class = 7

func changeValue(myStruct: inout MyStruct) {
    myStruct.number1Struct = 10
}

print(myStruct.number1Struct)
changeValue(myStruct: &myStruct)
print(myStruct.number1Struct)
