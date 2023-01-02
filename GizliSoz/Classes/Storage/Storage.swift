//
//  Storage.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import Foundation

final class Storage {
    
    static var share: Storage?
    
    static func appStart() {
        Storage.share = Storage()
        Storage.share?.fetchLevels()
    }
    
    var levels: [LevelResponse] = []
    var currentLevelIndex: Int = 1
    var currentLevel: LevelResponse? {
        guard currentLevelIndex > 0,
              levels.count >= currentLevelIndex
        else {
            AppLogger.critical(.logic, "Неправильно выставленный уровень")
            return nil
        }
        
        return levels[currentLevelIndex - 1]
    }
    
    // MARK: - Fetch functions
    
    /// Загрузка данных уровней
    private func fetchLevels() {
        API.Levels.getLevels.request([LevelResponse].self) { result in
            switch result {
            case .success(let data):
                self.levels = data
            case .failure(let error):
                AppLogger.log(.storage, error)
            }
        }
    }
}
