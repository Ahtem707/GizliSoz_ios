//
//  WordsListViewModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 30.03.2023.
//

import Foundation

final class WordsListViewModel: BaseViewModel {
    
    var delegate: WordsListViewControllerDelegate?
    
    private var sections: [WordHeaderData] = []
    private var words: [WordCellData] = []
    private var bonusWords: [WordCellData] = []
    
    func initialize() {
        sections.append(contentsOf: [
            .init(text: AppText.WordsListScreen.words),
            .init(text: AppText.WordsListScreen.bonusWords)
        ])
        
        guard let level = AppStorage.currentLevel else { return }
        words = level.words.values.map { WordCellData(word: $0.chars.joined(), translate: $0.description, isHaveSound: true) }
        bonusWords = level.bonusWords.map { WordCellData(word: $0, translate: $0, isHaveSound: true) }
    }
}

// MARK: - WordsListViewModelProtocol
extension WordsListViewModel: WordsListViewModelProtocol {
    
    func getSectionCount() -> Int {
        return sections.count
    }
    
    func getSection(_ section: Int) -> WordHeaderData {
        guard sections.count > section
        else {
            assertionFailure("Ошибка в секциях таблицы")
            return WordHeaderData.default
        }
        return sections[section]
    }
    
    func getCellCount(_ section: Int) -> Int {
        switch section {
        case 0: return words.count
        case 1: return bonusWords.count
        default: assertionFailure("Ошибка в секциях таблицы"); return 0
        }
    }
    
    func getCellData(_ indexPath: IndexPath) -> WordCellData {
        switch indexPath.section {
        case 0: return words[indexPath.row]
        case 1: return bonusWords[indexPath.row]
        default: assertionFailure("Ошибка в секциях таблицы"); return WordCellData.default
        }
    }
}
