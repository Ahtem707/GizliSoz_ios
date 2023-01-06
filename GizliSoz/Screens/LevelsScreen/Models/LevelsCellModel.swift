//
//  CellModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import Foundation

enum CellType {
    case normal
    case selected
    case locked
}

struct LevelsCellModel {
    let level: Int
    let type: CellType
}
