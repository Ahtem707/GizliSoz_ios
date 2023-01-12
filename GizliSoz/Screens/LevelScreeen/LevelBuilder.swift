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
        viewController.layouts = Layouts()
        viewController.appearance = Appearances()
        viewModel.delegate = viewController
        viewController.crossView.viewModel = viewModel
        viewModel.crossDelegate = viewController.crossView
        viewController.keyboardView.viewModel = viewModel
        viewModel.keyboardDelegate = viewController.keyboardView
        viewModel.initialize()
        return viewController
    }
    
    struct Layouts {
        let contentViewEdge = UIEdgeInsets(vertical: 5, horizontal: 20)
        let crossViewEdge = UIEdgeInsets(all: 0)
        let crossViewHeightMultiplier: CGFloat = 0.4
        let keyboardViewEdge = UIEdgeInsets(all: 0)
    }
    
    struct Appearances {
        let backImage: UIImage = AppImage.appBackground
    }
}

