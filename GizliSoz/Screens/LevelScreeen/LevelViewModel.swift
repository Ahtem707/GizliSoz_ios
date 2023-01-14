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
    
    private var bonusWordsCount: Int = 0
    
    private var openWords = 0
    
    func initialize() {
        
        guard let level = AppStorage.currentLevel else { return }
        
        delegate?.setTitle(level.name)
        
        crossDelegate?.clear()
        keyboardDelegate?.clear()
        
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
        keyboardDelegate?.setAdditionalStatus(type: .bonusWords, isActive: bonusWordsCount != 0, counter: "\(bonusWordsCount)")
        keyboardDelegate?.setAdditionalStatus(type: .sound, isActive: AppStorage.voiceActorIsActive, counter: nil)
        
        // Загружаем и подготавливаем озвучку слов
        let wordIds = level.words.compactMap { $0.value.id }
        SoundPlayer.share.clear()
        SoundPlayer.share.loadLevelSounds(ids: wordIds)
    }
}

// MARK: - Private methods
extension LevelViewModel {
    
    private func turnOffHammer() {
        let result = crossDelegate?.openByPressing(valueIfNeeded: false) ?? false
        keyboardDelegate?.setAdditionalSelected(type: .hammer, isSelected: result)
    }
    
    private func playSound(id: Int) {
        guard AppStorage.voiceActorIsActive else { return }
        SoundPlayer.share.play(id: id)
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
        if AppStorage.lastOpenedLevelIndex == AppStorage.currentLevelIndex {
            AppStorage.hintCount += 1
        }
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
        if let id = crossDelegate?.openWord(word: word) {
            openWords += 1
            playSound(id: id)
        } else {
            // Получаем текущий уровень
            guard let level = AppStorage.currentLevel else { return }
            
            if level.bonusWords.contains(where: { $0 == word }) &&
                !AppStorage.bonusWords.contains(where: { $0 == word }) {
                AppStorage.bonusWords.append(word)
                bonusWordsCount += 1
                keyboardDelegate?.setAdditionalStatus(type: .bonusWords, isActive: bonusWordsCount != 0, counter: "\(bonusWordsCount)")
                AppStorage.hammerCount += 1
                keyboardDelegate?.setAdditionalStatus(type: .hammer, isActive: AppStorage.hammerCount != 0, counter: "\(AppStorage.hammerCount)")
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
        AppStorage.voiceActorIsActive = !AppStorage.voiceActorIsActive
        keyboardDelegate?.setAdditionalStatus(type: .sound, isActive: AppStorage.voiceActorIsActive, counter: nil)
    }
}
