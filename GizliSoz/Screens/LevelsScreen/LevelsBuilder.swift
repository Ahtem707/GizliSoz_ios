//
//  LevelsBuilder.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import UIKit

final class LevelsBuilder {
    static func start() -> UIViewController {
        let viewController = LevelsViewController()
        let viewModel = LevelsViewModel()
        viewController.viewModel = viewModel
        viewController.layouts = Layouts()
        viewController.appearance = Appearances()
        viewModel.delegate = viewController
        viewModel.initialize()
        return viewController
    }
    
    struct Layouts {
        let collectionViewEdges: UIEdgeInsets = UIEdgeInsets(vertical: 10, horizontal: 30)
    }
    
    struct Appearances {
        let backImage: UIImage = AppImage.appBackground
    }
}
