import UIKit
import CoreImage

// https://www.swiftbysundell.com/posts/extending-optionals-in-swift

// CONVERT NIL INTO ERROR

enum ImagePreparationError: Error {
    case preparationFailed
    case anotherThingFailed
}

extension ImagePreparationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .preparationFailed:
            return NSLocalizedString("Preparation Failed", comment: "Image not sent")
        case .anotherThingFailed:
            return NSLocalizedString("Compression Failed", comment: "Image not send")
        }
    }
}

func prepareImageForUpload(_ image: UIImage) throws -> Data {
    guard let compressed = convertToData(image) else {
        throw ImagePreparationError.preparationFailed
    }
    
    guard let compressedImage = checkSize(compressed) else {
        throw ImagePreparationError.preparationFailed
    }
    
    return compressedImage
}

func convertToData(_ image: UIImage) -> Data? {
    return image.jpegData(compressionQuality: 40)
}

func checkSize(_ image: Data) -> Data? {
    // Encryption code
    return image.count > 40 ? image : nil
}


// Another way

extension Optional {
    func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        
        return value
    }
}

func prepareImageForUploadV2(_ image: UIImage) throws -> Data {
    return try convertToData(image)
                .flatMap(checkSize)
                .orThrow(ImagePreparationError.preparationFailed)
}

// EXPRESSIVE CHECKS

class FormViewController: UIViewController {
    
}

extension FormViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderColor = UIColor.green.cgColor
        }
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

class FormViewControllerV2: UIViewController {
    
}

extension FormViewControllerV2 {
    @objc func textFieldDidChangeV2(_ textField: UITextField) {
        textField.layer.borderColor = textField.text.isNilOrEmpty ? UIColor.red.cgColor : UIColor.green.cgColor
    }
}

// MATCHING AGAINST A PREDICATE

func performSearch(with query: String) {
    // Search code
}

class SearchBar {
    var text: String?
}

let searchBar = SearchBar()

func handleSearch() {
    guard let query = searchBar.text, query.count > 2 else {
        return
    }
    performSearch(with: query)
}

extension Optional {
    func withPredicate(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self else {
            return nil
        }
        
        guard predicate(value) else {
            return nil
        }
        
        return value
    }
}

func handleSearchV2() {
    searchBar.text.withPredicate { $0.count > 2 }
                  .map(performSearch)
}

// with more predicates

// let activeFriend = database.userRecord(withID: id)
//    .withPredicate { $0.isFriend }
//    .withPredicate { $0.isActive }
