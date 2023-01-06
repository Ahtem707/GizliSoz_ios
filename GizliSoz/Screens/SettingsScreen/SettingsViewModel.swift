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
    func makeDataSource() {
        let dataSource = [
            SettingsSwitchCellModel(title: "Inhar", isEnable: false, action: { value in
                AppStorage.infoMessage = value
            }),
            SettingsMoreCellModel(title: "Inhar tili", action: {
                // TODO: - This is need bottom sheet
            }),
            SettingsMoreCellModel(title: "Ses tili", action: {
                // TODO: - This is need bottom sheet
            }),
        ].compactMap { return $0 as? SettingsCellModel }
        self.dataSource.append(contentsOf: dataSource)
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
