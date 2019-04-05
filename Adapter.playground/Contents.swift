import UIKit

//The first one is object adapter which uses composition.
//There is an adaptee instance in adapter to
//do the job like the following figure and code tell us.


protocol Target {
    func request()
}

class Adapter: Target {
    var adaptee: Adaptee
    init(adaptee: Adaptee) {
        self.adaptee = adaptee
    }
    func request() {
        adaptee.specificRequest()
    }
}

class Adaptee {
    func specificRequest() {
        print("Specific request")
    }
}
// usage
let adaptee = Adaptee()
let tar = Adapter(adaptee: adaptee)
tar.request()


// The other one is class adapter which
// uses multiple inheritance to connect target and adaptee.


protocol SecondTarget {
    func request()
}

class SecondAdaptee {
    func specificRequest() {
        print("Specific request")
    }
}

class SecondAdapter: SecondAdaptee, SecondTarget {
    func request() {
        specificRequest()
    }
}

// usage
let secondTar = SecondAdapter()
secondTar.request()
