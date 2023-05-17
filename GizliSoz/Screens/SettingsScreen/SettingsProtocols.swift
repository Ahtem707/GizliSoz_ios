//
//  SettingsProtocols.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {
    func getViewTitle() -> String
    
    func getTableCount() -> Int
    
    func getTableItem(_ indexPath: IndexPath) -> SettingsCellModel
}

protocol SettingsViewControllerDelegate: AnyObject {
    func reloadTable(_ indexPath: IndexPath?)
}
