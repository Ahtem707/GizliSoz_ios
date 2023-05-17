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
            SettingsSwitchCellModel(
                title: AppText.SettingsScreen.hint,
                isEnable: AppStorage.infoMessage,
                action: { value in
                    AppStorage.infoMessage = value
                }
            ),
            SettingsValueCellModel(
                title: AppText.SettingsScreen.hintLang,
                value: AppStorage.translationLang.value,
                action: { [weak self] in
                    self?.showInfoLanguage()
                }
            ),
            SettingsValueCellModel(
                title: AppText.SettingsScreen.voiceoverActor,
                value: AppStorage.voiceoverActor.value,
                action: { [weak self] in
                    self?.showVoiceActorLanguage()
                }
            ),
        ].compactMap { return $0 as? SettingsCellModel }
        self.dataSource.removeAll()
        self.dataSource.append(contentsOf: dataSource)
    }
    
    private func showInfoLanguage() {
        let dataSource = AppStorage.translationLangs.map { item in
            return ActionSheetModel(
                code: item.code,
                title: item.value,
                action: {
                    AppStorage.translationLang = item
                    self.updateDataSource()
                }
            )
        }
        ActionSheetFactory.makeDinamic(dataSource: dataSource)
    }
    
    private func showVoiceActorLanguage() {
        let dataSource = AppStorage.voiceoverActors.map { item in
            return ActionSheetModel(
                code: item.code,
                title: item.value,
                action: {
                    AppStorage.voiceoverActor = item
                    self.updateDataSource()
                }
            )
        }
        ActionSheetFactory.makeDinamic(dataSource: dataSource)
    }
    
    private func updateDataSource() {
        makeDataSource()
        delegate?.reloadTable(nil)
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
