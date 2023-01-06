//
//  SettingsBuilder.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import Foundation
import UIKit

final class SettingsBuilder {
    
    static func start() -> UIViewController {
        let viewController = SettingsViewController()
        let viewModel = SettingsViewModel()
        viewModel.delegate = viewController
        viewController.layouts = Layouts()
        viewController.appearance = Appearances()
        viewController.viewModel = viewModel
        viewModel.initialize()
        return viewController
    }
    
    struct Layouts {
        let tableViewEdges = UIEdgeInsets(vertical: 10, horizontal: 10)
    }
    
    struct Appearances {
        let backImage: UIImage = AppImage.appBackground
    }
}
