//
//  SettingsViewModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import Foundation

final class SettingsViewModel: BaseViewModel {
    
    var delegate: SettingsViewControllerDelegate?
    
    private var dataSource: [SettingsCellModel] = []
    
    func initialize() {
        makeDataSource()
    }
}

// MARK: - Private functions
extension SettingsViewModel {
    private func makeDataSource() {
        let dataSource = [
            SettingsSwitchCellModel(title: "Inhar", isEnable: AppStorage.infoMessage, action: { value in
                AppStorage.infoMessage = value
            }),
            SettingsMoreCellModel(title: "Inhar tili", action: { [weak self] in
                self?.showInfoLanguage()
            }),
            SettingsMoreCellModel(title: "Ses tili", action: { [weak self] in
                self?.showVoiceActorLanguage()
            }),
        ].compactMap { return $0 as? SettingsCellModel }
        self.dataSource.append(contentsOf: dataSource)
    }
    
    private func showInfoLanguage() {
        let dataSource = [
            ActionSheetModel(key: "ru", title: "Русский", action: {
                AppStorage.infoMessageLanguage = "ru"
            }),
            ActionSheetModel(key: "en", title: "English", action: {
                AppStorage.infoMessageLanguage = "en"
            })
        ]
        ActionSheetFactory.makeDinamic(dataSource: dataSource)
    }
    
    private func showVoiceActorLanguage() {
        let dataSource = [
            ActionSheetModel(key: "default", title: "Ахтем", action: {})
        ]
        ActionSheetFactory.makeDinamic(dataSource: dataSource)
    }
}

// MARK: - SettingsViewModelProtocol
extension SettingsViewModel: SettingsViewModelProtocol {
    func getViewTitle() -> String {
        return "Sazlamalar"
    }
    
    func getTableCount() -> Int {
        return dataSource.count
    }
    
    func getTableItem(_ indexPath: IndexPath) -> SettingsCellModel {
        return dataSource[indexPath.row]
    }
}
