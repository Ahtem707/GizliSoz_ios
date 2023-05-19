//
//  LevelsViewModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import Foundation

final class LevelsViewModel: BaseViewModel {
    
    weak var delegate: LevelsViewControllerDelegate?
    
    func initialize() {
        
    }
}

// MARK: - Private methods
extension LevelsViewModel {
    
}

// MARK: - LevelViewModelProtocol
extension LevelsViewModel: LevelsViewModelProtocol {
    func getViewTitle() -> String {
        return AppText.LevelsScreen.levels
    }
    
    func getCollectionCount() -> Int {
        return AppStorage.share.levelsCount
    }
    
    func getCollectionItem(_ indexPath: IndexPath) -> LevelsCellModel {
        let type: CellType
        let localLevel = indexPath.row + 1
        if localLevel == AppStorage.currentLevelIndex {
            type = .selected
        } else if localLevel <= AppStorage.lastOpenedLevelIndex {
            type = .normal
        } else {
            type = .locked
        }
        let cellModel = LevelsCellModel(
            level: localLevel,
            type: type
        )
        return cellModel
    }
}
