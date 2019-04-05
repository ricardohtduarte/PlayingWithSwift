import UIKit

/////////////////////////////////////////////////
////////////      INHERITANCE    ////////////////
/////////////////////////////////////////////////

class Animal {
    func lives() {
        print("I am alive")
    }
}

class Mammal: Animal {
    var groundSpeed: Int?
    func run() {
        print("I run")
    }
}

class Bird: Animal {
    var airSpeed: Int?
    func fly() {
        print("I Fly")
    }
}

class Fish: Animal {
    var waterSpeed: Int?
    func swim() {
        print("I swim")
    }
}

class Tiger: Mammal {
    func tiger() {
        print("I am a tiger")
    }
}

class Hawk: Bird {
    func hawk() {
        print("I am an Hawk")
    }
}

class Piranha: Mammal {
    func piranha() {
        print("I am a Piranha")
    }
}

let tiger = Tiger()
print("INHERITANCE")
tiger.run()
tiger.lives()

// Penguin is a Fish that swims and runs
// Destroys the inheritance because we want to use two methods that don't exist in the Fish class
// SOLUTION: COMPOSITION


/////////////////////////////////////////////////
/////////////// COMPOSITION /////////////////////
/////////////////////////////////////////////////


protocol Livable {
    func live()
}

protocol Swimable {
    func swim()
}

protocol Runnable {
    func run()
}

protocol Flyable {
    func fly()
}

extension Livable {
    func live() {
        print("I live")
    }
}

extension Swimable {
    func swim() {
        print("I swim")
    }
}

extension Runnable {
    func run() {
        print("I run")
    }
}

extension Flyable {
    func fly() {
        print("I fly")
    }
}

class Penguin: Livable, Runnable, Swimable {
    func penguin() {
        print("I am penguin")
    }
    
    func run() {
        print("Another type of run")
    }
}

print("COMPOSITION")
let penguin = Penguin()
penguin.live()
penguin.run()
penguin.swim()


