//
//  LevelProtocols.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import UIKit

protocol LevelViewModelProtocol: AnyObject {
    /// Инициализация viewModel
    func initialize()
    
    /// Выключаем режим открытия ячейки молотком
    func turnOffHammerFromView()
}

protocol LevelViewControllerDelegate: AnyObject {
    /// Установить название экрана
    func setTitle(text: String, translate: String?)
    
    /// Навигация к viewController
    func presentVC(_ viewController: UIViewController)
    
    /// Событие прохождения всех уровней
    func levelsFinished()
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
    /// - Returns: Возвращает id октрытого слова, если слово удалось открыть
    func openWord(word: String) -> Int?
    
    /// Открывает случайную ячейку
    /// - Returns: Возвращает true если есть что отрыть
    func openRandom() -> Bool
    
    /// Запускает или блокирует возможность ручного открытия ячейки,
    /// требует замыкание openByPressingClosure
    /// - Parameter value: устанавливает конкретное значение
    /// - Returns: требует замыкание openByPressingClosure
    func openByPressing(valueIfNeeded: Bool?) -> Bool
    
    /// Очистка ячеек
    func clear()
}

protocol LevelKeyboardViewModelProtocol: AnyObject {
    /// Выключаем режим открытия ячейки молотком
    func turnOffHammerFromKeyboardView()
    
    /// Завершение составление слова
    func wordComplete(word: [String])
    
    /// Обработка нажатия подсказки
    func hintHandle()
    
    /// Обработка нажатия молотка
    func hammerHandle()
    
    /// Обработка нажатия на бонусные слова
    func bonusWords()
    
    /// Обработка нажатия озвучки
    func soundHandle()
    
    /// Повышаем уровень
    func levelUp(status: Bool)
}

protocol LevelKeyboardViewDelegate: AnyObject {
    /// Инициализация
    /// - Parameter input: Входные данные
    func initialize(input: KeyboardViewBuilder.Input)
    
    /// Установить состояние для дополнительных кнопок
    func setAdditionalStatus(type: AdditionalCellBuilder.Types, isActive: Bool, counter: String?)
    
    /// Установить состояние выбора для дополнительных кнопок
    func setAdditionalSelected(type: AdditionalCellBuilder.Types, isSelected: Bool)
    
    /// Очистка клавиатуры
    func clear()
    
    /// Успешное завершение уровня
    func levelComplete()
}
