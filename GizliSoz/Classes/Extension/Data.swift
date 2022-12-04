//
//  Data.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

public extension Data {
    
    enum ExtensionType: String {
        case empty = ""
        case json
        case pdf
    }
    
    static func json(from: Bundle = .main, fileName: String, with: ExtensionType = .empty) -> Data {
        guard let url = from.url(forResource: fileName, withExtension: with.rawValue) else {
            assertionFailure("Не найден \(with) \(fileName)")
            return Data()
        }
        do {
            let jsonData = try Data(contentsOf: url)
            return jsonData
        } catch {
            assertionFailure("Не удалось распарсить json \(fileName)")
            return Data()
        }
    }
    
    /// Json representation for console logs
    var prettyJson: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
