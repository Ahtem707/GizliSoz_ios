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
    
    /// Загрузка данных уровней
    var levels: [LevelResponse] = []
    
    // MARK: - Fetch functions
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
