import UIKit

////////////////////////////////////////////////////////////////
///////////// FUNCTIONS Chapter Advanced Swift /////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////
// Delegates, Foudation Style //
////////////////////////////////


// This pattern works really well due to the weak reference to the delegate
// This way classes that instanciate the delegate won't have to worry about
// retain cycles

protocol AlertViewDelegate: class {
    func didTapButton(atIndex: Int)
}

class AlertView {
    var buttons: [String]
    weak var delegate: AlertViewDelegate?
    
    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }
    
    func fire() {
        delegate?.didTapButton(atIndex: 1)
    }
}

class ViewController: AlertViewDelegate {
    let alert: AlertView
    
    init() {
        alert = AlertView(buttons: ["OK", "Cancel"])
        alert.delegate = self
    }
    
    func didTapButton(atIndex: Int) {
        print("Button Tapped")
    }
}


//////////////////////////////////////
/////////// Properties ///////////////
//////////////////////////////////////

// Special kind of methods: Computed properties and subscripts

//////// COMPUTED PROPERTIES ////////

// looks like a normal property but it doesn't use any memory
// to store its value. The value is computed on the fly when the variable is accessed


import CoreLocation

struct GPSTrack {
    var record: [(String, String)] = []
    var timestamps: [String] {
        return record.map { $0.1 }
    }
}

let track = GPSTrack(record: [("07.43","2018"), ("07.76", "2019")])
track.record
track.timestamps // each time we access the variable, it computes the result
// Be carefull with the complexity of this properties because callers may assume
// that accessing the property takes constant time O(1)


////////// CHANGE OBSERVERS //////////


// willSet: gets called immediately before the new value is stored
// didSet: gets called immediately after the new value is stored


enum State {
    case moving
    case stopped
}

class Robot {
    
    var stateObserver: State {
        didSet {
            print("Robot state has changed")
        }
    }
    
    // which is equivalent to:
    
    var stateValue: State = .stopped
    var state: State {
        get {
            return stateValue
        }
        set {
            print("Robot state has changed")
        }
    }
    
    init() {
        self.stateObserver = .stopped
    }
}

// Swift's property observers are a purely compile-time feature


////////// LAZY STORED PROPERTIES //////////

// Initializes the var lazily
// The property is only assigned when it is accessed
// Example

class Point {
    var x: Double
    var y: Double
    
    private(set) lazy var distanceFromOrigin: Double = (x*x + y*y).squareRoot()
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

var point = Point(x: 3, y: 4)
point.x
point.distanceFromOrigin // it's not computed until it's called
point.x += 10
point.x
point.distanceFromOrigin // problem: it's not updated if properties change

// Accessing a lazy property is a mutating operation which is why it's not
// very suitable for structs


//////// SUBSCRIPTS ////////

// something like dictionary[key] or array[0]
// hybrid of functions and computed properties
// like functions: they take parameters
// like computed properties: they can be either read-only or read-write
// like functions: we can overload them

// Custom subscript examples:

// Receives list of indexes -> Returns list of elements with those indexes

extension Collection {
    subscript(indexList: Index...) -> [Element] {
        var result: [Element] = []
        for index in indexList {
            result.append(self[index])
        }
        return result
    }
}

let array: [Int] = [1,2,3,4,5,6,7,8,9,10,11]
array[2, 3]

// Access a string by index

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

let string: String = "hello world"
string[3]


//////// SUBSCRIPTS ////////

struct Address {
    var code: Int
}

struct Person {
    let name: String
    var address: Address
}

let streetKeyPath = \Person.address.code
let nameKeyPath = \Person.name

let address = Address(code: 5100)
let person = Person(name: "Ricardo", address: address)

person[keyPath: nameKeyPath]
person[keyPath: streetKeyPath]


//////// The @escaping Annotation ////////

// In swift 1 and 2 a closure parameter was @escaping by default
// which meant the closure could escape during the function execution
// Since swift 3, closure paramaters were non-escaping by default which
// made the code "safe by default"

// non-escaping closure

typealias CompletionHandler = (Int) -> String

let handler: (Int) -> (String) = { integer in
    return "The number is \(integer)"
}

func giveTheNumber(completion: CompletionHandler) {
    let number = 10
    completion(number)
}

giveTheNumber(completion: handler)

// escaping closure

class AgeRequest {
    var sum: Int?
    var completionHandler: ((Int)->Void)?
    
    func getSumOf(array:[Int], handler: @escaping ((Int)->Void)) {
        var sum: Int = 0
        for value in array {
            sum += value
        }
        self.completionHandler = handler
    }
    
    func doSomething() {
        self.getSumOf(array: [16,756,442,6,23]) { [weak self] sum in
            guard let self = self else { return }
            print(sum)
            self.sum = sum
        }
    }
}

let request = AgeRequest()
request.doSomething()
