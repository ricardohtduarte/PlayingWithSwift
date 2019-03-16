// Codable and Decodable
// Source: Advanced Swift by Chris Eidhof, Ole Begemann, and Airspeed Velocity

import Foundation
import UIKit

struct Coordinate: Codable {
    var latidude: Double
    var longitude: Double
}

struct Placemark: Codable {
    var name: String
    var coordinate: Coordinate
    
    private enum CodingKeys: CodingKey {
        case name
        case coordinate
    }
    
    // Custom encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate, forKey: .coordinate)
        
    }
}

let places: [Placemark] = [Placemark(name: "Paris", coordinate: Coordinate(latidude: 23, longitude: 25)),
                           Placemark(name: "Porto", coordinate: Coordinate(latidude: 14, longitude: 15))]

var encodedPlacemarks: Data?


/////////////////////////////////////////
// Default Codable behaviour with JSON //
/////////////////////////////////////////

func encodePlaceMark() -> Bool {
    do {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(places) // returns Data type
        let jsonString = String(decoding: jsonData, as: UTF8.self)
        encodedPlacemarks = jsonData
        print("EncodedPlacemarks: ")
        print(jsonString)
        return true
    } catch {
        print(error.localizedDescription)
        return false
    }
}

func decodePlaceMark() -> [Placemark] {
    do {
        let decoder = JSONDecoder()
        let placemarks = try decoder.decode([Placemark].self, from: encodedPlacemarks!)
        return placemarks
    } catch {
        print("Could not decode")
        return []
    }
}

func executeDefaultCodable() {
    encodePlaceMark()
    let decodedPlaceMarks = decodePlaceMark()
    print("Decoded placeMarks")
    for place in decodedPlaceMarks {
        print(place.name)
        print(place.coordinate.latidude)
        print(place.coordinate.longitude)
        print("")
    }
}

//executeDefaultCodable()

// Three types of containers
//     - Single value containers: encode a single value
//     - Unkeyed containers: something like an array of encoded values
//     - Keyed containers: something like a dictionary, keys will be converted to strings or ints
// In json:
//   - keyed containers become JSON objects: {}
//   - unkeyed containers become JSON arrays: []
//   - single value containers become numbers, strings or null

// Example of what might be happening behind the scenes for encoding an Array

//extension Array: Encodable where Element: Encodable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.unkeyedContainer()
//        for element in self {
//            try container.encode(element)
//        }
//    }
//}


/////////////////////////////////////////
////// SOLVING PROBLEMS IN CODABLE //////
/////////////////////////////////////////

// Types that do not conform with codable

import CoreLocation

struct PlaceMarkCoreLocation {
    var name: String
    var coordinate: CLLocationCoordinate2D
}

// Problem: CLLocationCoordinate2D does not conform with codable and we cannot change the library
// Solutions

// SOLUTION: Encode the latitude and longitude values directly

extension PlaceMarkCoreLocation {
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.coordinate = CLLocationCoordinate2D(
                                latitude: try container.decode(Double.self, forKey: .latitude),
                                longitude: try container.decode(Double.self, forKey: .longitude))
    }
}

// Problem: enums with associated values do not conform with protocols
// however, associated values must conform with Codable
// SOLUTION

enum CodableEnum: Codable {
    case left(String)
    case right(Int)
    
    private enum CodingKeys: CodingKey {
        case left
        case right
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .left(let value):
            try container.encode(value, forKey: .left)
        case .right(let value):
            try container.encode(value, forKey: .right)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let leftValue = try container.decodeIfPresent(String.self, forKey: .left) {
            self = .left(leftValue)
        } else {
            let rightValue = try container.decode(Int.self, forKey: .right)
            self = .right(rightValue)
        }
    }
}
