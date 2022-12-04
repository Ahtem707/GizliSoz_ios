//
//  LevelProtocols.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import Foundation

protocol LevelViewModelProtocol: AnyObject {
    
}

protocol LevelViewControllerDelegate: AnyObject {
    
    /// Успешное завершение уровня
    func levelComplete()
}

protocol LevelCrossViewModelProtocol: AnyObject {
    /// Вызывается если ячейка открыта по нажатию
    func openByPressingClosure()
    
    /// Вызывается при открытии всех слов
    func wordsCompleted()
}

protocol LevelCrossViewDelegate: AnyObject {
    /// Инициализация
    /// - Parameter input: Входные данные
    func initialize(input: CrossViewBuilder.Input)
    
    /// Открыть слово если оно есть
    /// - Parameter word: Искомое слово
    /// - Returns: Возвращает true если слово найдено и открыто
    func openWord(word: String) -> Bool
    
    /// Открывает случайную ячейку
    /// - Returns: Возвращает true если есть что отрыть
    func openRandom() -> Bool
    
    /// Запускает возможность ручного открытия ячейки,
    /// требует замыкание openByPressingClosure
    func openByPressing()
}

protocol LevelKeyboardViewModelProtocol: AnyObject {
    /// Завершение составление слова
    func workComplete(word: [String])
}

protocol LevelKeyboardViewDelegate: AnyObject {
    /// Инициализация
    /// - Parameter input: Входные данные
    func initialize(input: KeyboardViewBuilder.Input)
    
    /// Очистка клавиатуры
    func clear()
}
