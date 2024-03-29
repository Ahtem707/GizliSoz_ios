//
//  WordsListBuilder.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 30.03.2023.
//

import UIKit

final class WordsListBuilder {
    static func start(openWords: [Int], openBonusWords: [Int]) -> UIViewController {
        let viewController = WordsListViewController()
        let viewModel = WordsListViewModel(openWords: openWords, openBonusWords: openBonusWords)
        viewModel.delegate = viewController
        viewController.viewModel = viewModel
        viewModel.initialize()
        viewController.layouts = Layouts()
        viewController.appearance = Appearances()
        
        return BottomSheetContainerViewController(viewController)
    }
    
    struct Layouts {
        let tableViewEdges = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    struct Appearances {
        
    }
}
