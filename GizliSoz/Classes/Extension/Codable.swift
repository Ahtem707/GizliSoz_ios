//
//  Codable.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 12.05.2023.
//

import Foundation

extension Encodable {
  func asDictionary() -> [String : Any] {
    guard let data = try? JSONEncoder().encode(self)
    else { AppLogger.error(.api, AppError.asDictionary); return [:] }
      
    guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    else { AppLogger.error(.api, AppError.asDictionary); return [:] }
    
    return dictionary
  }
}

@propertyWrapper
struct FailableDecodable<Wrapped: Codable>: Codable {
    var wrappedValue: Wrapped?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try? container.decode(Wrapped.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
