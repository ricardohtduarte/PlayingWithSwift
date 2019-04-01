import PlaygroundSupport
import Foundation

// SWIFT 5 MAIN CHANGES

///////////////////////////////////////////////
/////////////// SE-0235 Result ////////////////
///////////////////////////////////////////////

let url = "https://www.hackingwithswift.com"

enum NetworkError: Error {
    case badURL
    case serverFailure
}


func fetchUnreadCount(from urlString: String, completionHandler: @escaping (Result<Int, NetworkError>) -> Void) {
    guard let url = URL(string: urlString) else {
        completionHandler(.failure(.badURL))
        return
    }
    
    // some code
    
    print("Fetching \(url.absoluteString)...")
    let responseStatus = 305
    if responseStatus >= 200 && responseStatus < 300 {
        completionHandler(.success(responseStatus))
    } else {
        completionHandler(.failure(.serverFailure))
    }
}


fetchUnreadCount(from: url) { result in
    switch result {
    case .success(let count):
        print("~\(count)")
    case .failure(let error):
        print(error)
    }
}

// Result has a get method


// Optional try

print("")
print("Optional try")
print("")

fetchUnreadCount(from: url, completionHandler: { result in
    if let count = try? result.get() {
        print("\(count)")
    } else {
        print("Could not get the error and this is the disadvantage of oprional try")
    }
})

// Do catch

print("")
print("Do catch")
print("")

fetchUnreadCount(from: url) { result in
    var count: Int
    do {
        count = try result.get()
        print(count)
    } catch {
        print(error)
    }
}


// Example of file contents

let fileURL = Bundle.main.url(forResource: "test", withExtension: "")
let result = Result { try String(contentsOf: fileURL!) }

switch result {
case .success(let content):
    print(content)
case .failure(let error):
    print(error)
}

///////////////////////////////////////////////////
// SE-0230 Flattening nested optionals from try? //
///////////////////////////////////////////////////

struct User {
    var id: Int
    
    // failable init
    init?(id: Int) {
        if id < 1 {
            return nil
        }
        self.id = id
    }
    
    func get() throws -> String {
        return ""
    }
}

let user = User(id: 1)
let messages = try? user?.get() // it's not a nested optional anymore, it just returns an optional string


///////////////////////////////////////////////////
///////////// SE-0200 Raw Strings /////////////////
///////////////////////////////////////////////////

// We can use # as delimiter
let rawString = #"something in "something" well."#
print(rawString)

// If we want to user a # in the string, add another # at the beginning and at the end

let rawString2 = ##"something # in "something" well."##
print(rawString2)

// With string interpolation add another #

let count = 10
let rawInterpoletedString = #"\(count) won't work but this will \#(count)"#

// good for regulard expressions with a lot of \

///////////////////////////////////////////////////
/////////// SE-0225 Integer Multiples /////////////
///////////////////////////////////////////////////

// Old way

let number = 4

extension Int {
    func isMultiple(ofInteger number: Int) -> Bool {
        guard number > 0 else {
            return false
        }
        
        if self % number == 0 {
            return true
        }
        else {
            return false
        }
    }
}

number.isMultiple(ofInteger: 2)

// New way

number.isMultiple(of: 2)

// Now checking if a number is even or odd is as easy as

extension Int {
    func isEven() -> Bool {
        return self.isMultiple(of: 2)
    }
    
    func isOdd() -> Bool {
        return !self.isMultiple(of: 2)
    }
}

5.isEven()
6.isEven()

10.isOdd()
11.isOdd()


///////////////////////////////////////////////////
//// SE-0228 Improved string interpolation ////////
///////////////////////////////////////////////////

struct SomeUser {
    var name: String
    var age: Int
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: SomeUser) {
        appendInterpolation("My name is \(value.name) and I'm \(value.age)")
    }
}

let someUser = SomeUser(name: "Ricardo", age: 23)
print("")
print("User: \(someUser)")


///////////////////////////////////////////////////
//// SE-0218 Compacting Dictionary Values  ////////
///////////////////////////////////////////////////

let times = [
    "John" : "38",
    "Smith" : "42",
    "Will" : "30",
]

let newTimes = [
    "John" : "44",
    "Will" : nil
]


print(times)

// Converts all the String values to Integers
let finishers1 = times.compactMapValues { Int($0) }
print(finishers1)

// Or
let finishers2 = times.compactMapValues(Int.init)
print(finishers2)

// Remove nil items from the dictionary
let finishers3 = newTimes.compactMapValues { $0 }
print(finishers3)


///////////////////////////////////////////////////
//////// SE-0192 Non-exhaustive enums  ////////////
///////////////////////////////////////////////////

enum PasswordError: Error {
    case short
    case obvious
    case simple
}

func showOld(error: PasswordError) {
    switch error {
    case .short:
        print("something short")
    case .obvious:
        print("something ovious")
    @unknown default:
        print("something unknown")
    }
}

// Now it gives us a warning instead of an error
// so that the code won't break has we add a new case
