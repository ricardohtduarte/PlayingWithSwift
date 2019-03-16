//////////////////
//// CLOSURES ////
//////////////////



///////////////////////////
//// STARTING EXAMPLES ////
///////////////////////////

// Normal function

func sum(x: Int, y: Int) -> Int {
    return x + y
}
print("Function: \(sum(x: 2, y: 2))")

// Closure

var sumClosure: (Int, Int) -> Int = { x, y in
    return x + y
}
print("Closure: \(sumClosure(2,2))")

// Simplified Closure

var closureSimplified: (Int, Int) -> Int = { return $0 + $1 }
print("Simplified Closure: \(closureSimplified(2,2))")


////////////////////////////////////////
//// Reference Cycles with Closures ////
////////////////////////////////////////

import Foundation

class RequestHandler {
    func handling(data: Data) -> String {
        return ("Handling the request...")
    }
}

class MockRequest {
    let handler = RequestHandler()
    
    func request() {
        let request = URLRequest(url: URL(string: "www.google.com")!)
        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self else {
                return
            }
            
            guard let data = data else {
                return
            }
            self.handler.handling(data: data)
            // ARC will increment the reference counter for handle because the closure captured the variable with a strong reference, therefore, we can solve this by using a CAPTURE LIST and making the reference to the variable weak, in this case, the variable is self which is MockRequest. We could use unowned and it would not increment ARC (and it wouldn't be necessary to unwrap self), but we would have to ensure the we would not access MockRequest after it's deinitialization, otherwise the program would crash
        }
    }
}

////////////////////////////////////////
////////// Completion Blocks ///////////
////////////////////////////////////////
