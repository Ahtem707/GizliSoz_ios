//
//  AdvancedOperators.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 19.05.2023.
//

import Foundation

/// Опциональное присвоение, если значение справа от оператора равно nil, то присваивание значения в переменную слева не выполняется
infix operator ?=
func ?=<T> (lhs: inout T, rhs: T?) {
    if rhs != nil {
        lhs = rhs!
    }
}

/// Принудительное извлечение значения, которое может вызывать исключение
postfix operator .!!
postfix func .!!<T> (rhs: T?) throws -> T {
    if rhs == nil {
        throw NSError(domain: "Assignment error", code: 0)
    } else {
        return rhs!
    }
}
