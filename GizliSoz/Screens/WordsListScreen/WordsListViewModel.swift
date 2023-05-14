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
    private var openWords: [Int]
    private var openBonusWords: [Int]
    
    init(openWords: [Int], openBonusWords: [Int]) {
        self.openWords = openWords
        self.openBonusWords = openBonusWords
    }
    
    func initialize() {
        sections.append(contentsOf: [
            .init(text: AppText.WordsListScreen.words),
            .init(text: AppText.WordsListScreen.bonusWords)
        ])
        
        guard let level = AppStorage.currentLevel else { return }
        
        words = level.words.compactMap {
            return WordCellData(
                id: $0.id,
                word: $0.word,
                translate: $0.translate,
                isHaveSound: SoundPlayer.share.hasSound(id: $0.id),
                isMasked: !openWords.contains($0.id)
            )
        }
        bonusWords = level.bonusWords.map {
            return WordCellData(
                id: $0.id,
                word: $0.word,
                translate: $0.translate,
                isHaveSound: SoundPlayer.share.hasSound(id: $0.id),
                isMasked: !openBonusWords.contains($0.id)
            )
        }
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
