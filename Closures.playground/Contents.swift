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
////////// Closure Callback ////////////
////////////////////////////////////////

class ViewModel {
    typealias RequestHandler = (String) -> ()
    var communication: RequestHandler?
    
    enum CommunicationStatus {
        case on(String)
        case off
    }
    
    let communicationStatus: CommunicationStatus = .on("Info received")
    
    func communicateWithViewModel() {
        switch communicationStatus {
        case .on(let info):
            communication?(info)
        case .off:
            print("Communication is off")
        }
    }
}

class ViewController {
    let viewModel = ViewModel()
    var info: String?
    
    init() {
        // assign the content of the function for when it's called in the ViewModel
        viewModel.communication = { [weak self] info in
            guard let self = self else { return }
            self.info = info
        }
    }
}

let viewController = ViewController()
print(viewController.info as Any)
viewController.viewModel.communicateWithViewModel()
print(viewController.info as Any)

////////////////////////////////////////
////////// Completion Block ////////////
////////////////////////////////////////

typealias Comunicate = (String) -> ()

class ViewModel2 {
    
    enum CommunicationStatus {
        case on(String)
        case off
    }
    
    let communicationStatus: CommunicationStatus = .on("Info received")
    
    func communicateWithViewModel(completion: Comunicate) {
        switch communicationStatus {
        case .on(let info):
            completion(info)
        case .off:
            print("Communication is off")
        }
    }
}

class ViewController2 {
    let viewModel = ViewModel2()
    var info: String?
    
    init() {
        
        let completion: Comunicate = { [weak self] info in
            guard let self = self else { return }
            self.info = info
        }
        
        viewModel.communicateWithViewModel(completion: completion)
    }
}

let viewController2 = ViewController2()
print(viewController2.info as Any)
