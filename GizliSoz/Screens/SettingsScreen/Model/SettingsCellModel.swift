//
//  SettingsCellModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import Foundation

protocol SettingsCellModel {}

struct SettingsSwitchCellModel: SettingsCellModel {
    let title: String
    let isEnable: Bool
    let action: (_ value: Bool) -> Void
}

struct SettingsMoreCellModel: SettingsCellModel {
    let title: String
    let action: () -> Void
}
