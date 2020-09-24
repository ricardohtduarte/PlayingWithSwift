// Swift by sundell March 31 2019

import UIKit
import PlaygroundSupport

struct User {
    let name: String
    let age: Int
}

enum Result {
    case success(User)
    case failure(Error)
}

enum UserError: Error {
    case errorFetchingUser
}

extension UserError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .errorFetchingUser:
            return "Error: could not fetch user"
        }
    }
}

class UserLoader {
    let isSuccess: Bool = true
    func load(callback: @escaping (Result) -> ()) {
        guard isSuccess else {
            callback(.failure(UserError.errorFetchingUser))
            return
        }
        
        print("Fetching user...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            callback(.success(User(name: "Ricardo", age: 23)))
        }
    }
}

// CONSTANT UPDATES
class ConstantUpdatesViewController: UIViewController {
    private let userLoader: UserLoader
    private lazy var nameLabel = UILabel()
    private lazy var ageLabel = UILabel()
    
    init(userLoader: UserLoader) {
        self.userLoader = userLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userLoader.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.nameLabel.text = user.name
                self.ageLabel.text = String(user.age)
                
                print(self.nameLabel.text!)
                print(self.ageLabel.text!)
            case .failure(let error):
                print(error)
            }
        }
    }
}

var constantUpdatesViewController = ConstantUpdatesViewController(userLoader: UserLoader()) as PlaygroundLiveViewable
PlaygroundPage.current.liveView = constantUpdatesViewController

//Disadvantages of this approach:
//    - We have to keep references to the views as properties in the viewController since we cannot
//      assign UI properties until the model is loaded
//    - We have to weakly reference self
//    - Each time the viewController is presented we have to reload the model

// Instead of having the view controller load the model, we could use something like a
// UserHolder to pass in an observable wrapper around our core User model

// BINDABLE

//  The idea behind value binding is to enable us to write auto-updating UI code by simply associating each piece of model data with a UI property,

class Bindable<Value> {
    private var observations = [(Value) -> Bool]() // whatever view properties that will observe
    private var lastValue: Value?
    
    init(_ value: Value? = nil) {
        lastValue = value
    }
    
    private func addObservation<O: AnyObject>(for object: O,
                                              handler: @escaping (O, Value) -> Void) {
        // If we already have a value available, we'll give the
        // handler access to it directly.
        // cool way to unwrap the lastValue by the way
        lastValue.map { handler(object, $0) }
        
        // Each observation closure returns a Bool that indicates
        // whether the observation should still be kept alive,
        // based on whether the observing object is still retained.
        observations.append { [weak object] value in
            guard let object = object else {
                return false
            }
            
            handler(object, value)
            return true
        }
    }
    
    func update(with value: Value) {
        lastValue = value // update the bindable last value
        observations = observations.filter { $0(value) }  // to remove all observations that have become outdated
    }
    
    func bind<O: AnyObject, T>(_ sourceKeyPath: KeyPath<Value, T>,
                               to object: O,
                               _ objectKeyPath: ReferenceWritableKeyPath<O, T>) {
        addObservation(for: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            object[keyPath: objectKeyPath] = value
        }
    }
    func bind<O: AnyObject, T>(_ sourceKeyPath: KeyPath<Value, T>,
                               to object: O,
                               _ objectKeyPath: ReferenceWritableKeyPath<O, T?>) {
        addObservation(for: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            object[keyPath: objectKeyPath] = value
        }
    }

    func bind<O: AnyObject, T, R>(_ sourceKeyPath: KeyPath<Value, T>,
                                  to object: O,
                                  _ objectKeyPath: ReferenceWritableKeyPath<O, R?>,
                                  transform: @escaping (T) -> R?) {
        addObservation(for: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            let transformed = transform(value)
            object[keyPath: objectKeyPath] = transformed
        }
    }
}


class BindableViewController: UIViewController {
    private let user: Bindable<User>
    
    init(user: Bindable<User>) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNameLabel()
        addAgeLabel()
    }
    
    private func addNameLabel() {
        let label = UILabel()
        user.bind(\.name, to: label, \.text)
        view.addSubview(label)
    }
    
    private func addAgeLabel() {
        let label = UILabel()
        user.bind(\.age, to: label, \.text, transform: String.init)
        view.addSubview(label)
    }
}
