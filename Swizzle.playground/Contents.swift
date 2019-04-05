import UIKit


public extension UIColor {
    @objc func colorDescription() -> String {
        return "Printing rainbow colours."
    }
    
    private static let swizzleDesriptionImplementation: Void = {
        let instance: UIColor = UIColor.red
        let aClass: AnyClass! = object_getClass(instance)
        let originalMethod = class_getInstanceMethod(aClass, #selector(description))
        let swizzledMethod = class_getInstanceMethod(aClass, #selector(colorDescription))
        
        if let originalMethod = originalMethod,
           let swizzledMethod = swizzledMethod {
            // switch implementation..
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()
    
    public static func swizzleDesription() {
        _ = self.swizzleDesriptionImplementation
    }
}


print(UIColor.red)
UIColor.swizzleDesription()
print(UIColor.red)
