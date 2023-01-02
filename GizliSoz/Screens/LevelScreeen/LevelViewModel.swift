//
//  LevelViewModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import Foundation

final class LevelViewModel: BaseViewModel {
    
    weak var delegate: LevelViewControllerDelegate?
    weak var crossDelegate: LevelCrossViewDelegate?
    weak var keyboardDelegate: LevelKeyboardViewDelegate?
    
    private var bonusWords: [String] = []
    private var sound = false
    
    private var openWords = 0
    
    func initialize() {
        guard let level = AppStorage.currentLevel else { return }
        
        let words: [CrossViewBuilder.Word] = level.words.map { word, wordData in
            
            var cellsData: [CrossViewBuilder.CellData] = []
            var i: Int = 0
            while i < wordData.chars.count {
                let cellData = CrossViewBuilder.CellData(
                    x: wordData.x[i],
                    y: wordData.y[i],
                    char: wordData.chars[i]
                )
                
                cellsData.append(cellData)
                i += 1
            }
            
            return CrossViewBuilder.Word(
                id: wordData.id,
                word: word,
                chars: cellsData
            )
        }
        
        let crossViewInput: CrossViewBuilder.Input = .init(
            size: level.size,
            words: words
        )
        
        // Отправляем данные в CrossView
        crossDelegate?.initialize(input: crossViewInput)
        
        let keyboardViewInput: KeyboardViewBuilder.Input = .init(
            chars: level.chars
        )
        
        // Отправляем данные в KeyboardView
        keyboardDelegate?.initialize(input: keyboardViewInput)
        
        // Устанавливаем состояние дополнительных кнопок
        keyboardDelegate?.setAdditionalStatus(type: .hint, isActive: AppStorage.hintCount != 0, counter: "\(AppStorage.hintCount)")
        keyboardDelegate?.setAdditionalStatus(type: .hammer, isActive: AppStorage.hammerCount != 0, counter: "\(AppStorage.hammerCount)")
        keyboardDelegate?.setAdditionalStatus(type: .bonusWords, isActive: bonusWords.count != 0, counter: "\(bonusWords.count)")
        keyboardDelegate?.setAdditionalStatus(type: .sound, isActive: sound, counter: nil)
    }
}

// MARK: - Private methods
extension LevelViewModel {
    private func turnOffHammer() {
        let result = crossDelegate?.openByPressing(valueIfNeeded: false) ?? false
        keyboardDelegate?.setAdditionalSelected(type: .hammer, isSelected: result)
    }
}

// MARK: - LevelViewModelProtocol
extension LevelViewModel: LevelViewModelProtocol {
    func turnOffHammerFromView() {
        turnOffHammer()
    }
}

// MARK: - LevelCrossViewModelProtocol
extension LevelViewModel: LevelCrossViewModelProtocol {
    
    func openByPressingClosure() {
        AppStorage.hammerCount -= 1
        keyboardDelegate?.setAdditionalSelected(type: .hammer, isSelected: false)
        keyboardDelegate?.setAdditionalStatus(type: .hammer, isActive: AppStorage.hammerCount != 0, counter: "\(AppStorage.hammerCount)")
    }
    
    func wordsCompleted() {
        delegate?.levelComplete()
    }
}

// MARK: - LevelKeyboardViewModelProtocol
extension LevelViewModel: LevelKeyboardViewModelProtocol {
    
    func turnOffHammerFromKeyboardView() {
        turnOffHammer()
    }
    
    func wordComplete(word: [String]) {
        let word = word.reduce("", {$0 + $1})
        if crossDelegate?.openWord(word: word) ?? false {
            openWords += 1
        } else {
            // Получаем текущий уровень
            guard let level = AppStorage.currentLevel else { return }
            
            if level.bonusWords.contains(where: { $0 == word }) &&
                !bonusWords.contains(where: { $0 == word }) {
                bonusWords.append(word)
                keyboardDelegate?.setAdditionalStatus(type: .bonusWords, isActive: bonusWords.count != 0, counter: "\(bonusWords.count)")
            }
        }
    }
    
    func hintHandle() {
        if AppStorage.hintCount > 0 {
            let result = crossDelegate?.openRandom() ?? false
            if result {
                AppStorage.hintCount -= 1
                keyboardDelegate?.setAdditionalStatus(type: .hint, isActive: AppStorage.hintCount != 0, counter: "\(AppStorage.hintCount)")
            }
        } else {
            keyboardDelegate?.setAdditionalStatus(type: .hint, isActive: false, counter: nil)
        }
    }
    
    func hammerHandle() {
        if AppStorage.hammerCount > 0 {
            let result = crossDelegate?.openByPressing(valueIfNeeded: nil) ?? false
            keyboardDelegate?.setAdditionalSelected(type: .hammer, isSelected: result)
            
        } else {
            keyboardDelegate?.setAdditionalStatus(type: .hammer, isActive: false, counter: nil)
        }
    }
    
    func soundHandle() {
        print("Запуск музыки")
    }
}
