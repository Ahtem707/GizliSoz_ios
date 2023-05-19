//
//  Array.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

extension Array where Element: Equatable {
    /// Удаляет дубликаты в массиве
    func removeDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
    
    /// Объедиеняет массив любых элементов по разделителю
    func join(separator: String = ",") -> String {
        var str: [String] = []
        for item in self {
            str.append("\(item)")
        }
        return str.joined(separator: separator)
    }
}
