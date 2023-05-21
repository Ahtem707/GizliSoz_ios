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
        let dataSource: [SettingsCellModel] = [
            SettingsSwitchCellModel(
                title: AppText.SettingsScreen.infoMessage,
                isEnable: AppStorage.infoMessage,
                action: { [weak self] value in
                    AppStorage.infoMessage = value
                    self?.delegate?.showExampleInfoMessage()
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
            SettingsValueCellModel(
                title: AppText.SettingsScreen.levelsCache,
                value: "\(AppStorage.levelsCacheCount)",
                action: { [weak self] in
                    self?.showCacheCount()
                }
            ),
            SettingsValueCellModel(
                title: AppText.SettingsScreen.alphabet,
                value: "\(AppStorage.characterType.text)",
                action: { [weak self] in
                    self?.showSelectCharType()
                }
            ),
        ].compactMap { return $0 as? SettingsCellModel }
        self.dataSource.removeAll()
        self.dataSource.append(contentsOf: dataSource)
    }
    
    private func showInfoLanguage() {
        let dataSource = AppStorage.share.translationLangs.map { item in
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
        let dataSource = AppStorage.share.voiceoverActors.map { item in
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
    
    private func showCacheCount() {
        let cacheVariable = [2, 5, 10, 20, 50]
        let dataSource = cacheVariable.map { item in
            let itemStr = String(item)
            return ActionSheetModel(
                code: itemStr,
                title: itemStr,
                action: {
                    AppStorage.levelsCacheCount = item
                    self.updateDataSource()
                }
            )
        }
        ActionSheetFactory.makeDinamic(dataSource: dataSource)
    }
    
    private func showSelectCharType() {
        let charsType: [CharacterType] = [.latin, .cyrillic]
        let dataSource = charsType.map { item in
            return ActionSheetModel(
                code: item.rawValue,
                title: item.text,
                action: {
                    AppStorage.characterType = item
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
        return AppText.SettingsScreen.settings
    }
    
    func getTableCount() -> Int {
        return dataSource.count
    }
    
    func getTableItem(_ indexPath: IndexPath) -> SettingsCellModel {
        return dataSource[indexPath.row]
    }
}
