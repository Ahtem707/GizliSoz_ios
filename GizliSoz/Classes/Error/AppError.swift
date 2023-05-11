//
//  AppError.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import Foundation

extension AppError {
    var localizedDescription: String {
        return self.rawValue
    }
}

enum AppError: String, Error {
    case urlMakeFailed = "Не удалось сгенерировать запрос"
    case contentError = "Ошибка возвращения данных"
    case sound = "Ошибка воспроизведения звука"
}
