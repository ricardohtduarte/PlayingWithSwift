import Foundation

// Option 1: Empty default implementation

protocol Option1 {
    func thisIsMandatory()
    func thisIsOptional()
}

extension Option1 {
    func thisIsOptional() {}
}

struct Struct1: Option1 {
    func thisIsMandatory() {
        print("Only need to implement this one")
    }
}

// Advantages

//We can also conform structures to a protocol
//Default implementation inside the extension is automatically used when we don’t implement the method inside the conforming type


//Disadvantages

//In cases when an optional method returns a non-Void value, we’ll need to come up with and return some value inside the default implementation

// Option 2: Objective-C ‘optional’ Keyword

@objc protocol Option2 {
    func thisIsMandatory()
    @objc optional func thisIsOptional()
}

//Advantages

//No need to create an extension

//Disadvantages

//Only NSObject subclasses can inherit from an @objc protocol. That means we cannot conform structs or enums to the protocol.
//If we suddenly need to call an optional method, we must include the ? or ! symbol after the method’s name (if we use force unwrap and the method is not implemented, the app will crash):
