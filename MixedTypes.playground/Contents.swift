import Foundation
import UIKit

//https://www.swiftbysundell.com/questions/array-with-mixed-types/

struct Video {
    let id: String
    let length: TimeInterval
}

struct Photo {
    let id: String
    let size: CGSize
}

///////////////////////////////
//// FIRST SOLUTION -> ANY ////
///////////////////////////////


// Circumvent swift's strong type system

let anyMedia: [Any] = [Photo(id: "First photo", size: CGSize(width: 10.0, height: 10.0)),
                       Video(id: "First video", length: 10.0)]

// Get photo

let photo: Photo = anyMedia[0] as! Photo

// Needs typecasting, we don't get any warnings in compile time on what the instances of the array are

//////////////////////////////////////////////
//// SECOND SOLUTION -> Protocol oriented ////
//////////////////////////////////////////////

protocol Item {
    var id: String { get }
}

extension Photo: Item {}
extension Video: Item {}

// Now we can have an array in which you can only have Photos or Videos
let specificMedia: [Item] = [Photo(id: "Second photo", size: CGSize(width: 10.0, height: 10.0)),
                             Video(id: "Second video", length: 10.0)]

//////////////////////////////////////////////
////// THIRD SOLUTION -> Enum oriented ///////
//////////////////////////////////////////////

enum ItemEnum {
    case video(Video)
    case photo(Photo)
}

extension ItemEnum: Identifiable {
    var id: String {
        switch self {
        case .video(let video):
            return video.id
        case .photo(let photo):
            return photo.id
        }
    }
}


/////////////////////////////////////////////////////////
////// THIRD SOLUTION -> Enum and Struct oriented ///////
/////////////////////////////////////////////////////////

// Common items in the struct and specific items in enum

struct ItemStruct: Identifiable {
    let id: String
}

extension ItemStruct {
    enum Metadata {
        case video(length: TimeInterval)
        case photo(size: CGSize)
    }
}
