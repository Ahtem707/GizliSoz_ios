//
//  LevelsProtocol.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import Foundation

protocol LevelsViewModelProtocol: AnyObject {
    func getViewTitle() -> String
    
    func getCollectionCount() -> Int
    
    func getCollectionItem(_ indexPath: IndexPath) -> LevelsCellModel
}

protocol LevelsViewControllerDelegate: AnyObject {
    
}
