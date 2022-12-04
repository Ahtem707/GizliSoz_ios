//
//  LevelBuilder.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import UIKit

final class LevelBuilder {
    
    static func start() -> UIViewController {
        let viewController = LevelViewController()
        let viewModel = LevelViewModel()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        viewController.crossView.viewModel = viewModel
        viewModel.crossDelegate = viewController.crossView
        viewController.keyboardView.viewModel = viewModel
        viewModel.keyboardDelegate = viewController.keyboardView
        viewModel.initialize()
        viewController.layouts = Layouts()
        viewController.appearance = Appearances()
        return viewController
    }
    
    struct Layouts {
        let crossViewEdge: UIEdgeInsets = UIEdgeInsets(vertical: 20, horizontal: 20)
        let keyboardViewEdge: UIEdgeInsets = UIEdgeInsets(vertical: 10, horizontal: 20)
    }
    
    struct Appearances {
        let backImage: UIImage = AppImage.appBackground
    }
}

