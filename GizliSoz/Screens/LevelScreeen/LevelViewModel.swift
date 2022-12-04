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
    
    func initialize() {
        guard let level = Storage.share?.levels.first else { return }
        
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
    }
}

// MARK: - MainViewModelProtocol
extension LevelViewModel: LevelViewModelProtocol {
    
}

extension LevelViewModel: LevelCrossViewModelProtocol {
    func openByPressingClosure() {
        
    }
    
    func wordsCompleted() {
        delegate?.levelComplete()
    }
}

extension LevelViewModel: LevelKeyboardViewModelProtocol {
    func workComplete(word: [String]) {
        let word = word.reduce("", {$0 + $1})
        let result = crossDelegate?.openWord(word: word)
        if result ?? false {
            print("success open word, increment counter")
        }
    }
}
