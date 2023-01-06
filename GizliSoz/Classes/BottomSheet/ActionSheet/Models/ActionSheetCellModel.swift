//
//  ActionSheetCellModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import Foundation

typealias ActionCompletion = () -> Void

struct ActionSheetModel {
    let code: String
    let title: String
    let action: ActionCompletion
}
