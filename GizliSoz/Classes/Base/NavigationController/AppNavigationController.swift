//
//  AppNavigationController.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import UIKit

final class AppNavigationController: UINavigationController {
    
    enum Screens {
        case main
        
        var viewController: UIViewController {
            switch self {
            case .main:
                return MainBuilder.start()
            }
        }
    }
    
    // MARK: - Lifecicle functions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushViewController(Screens.main.viewController, animated: false)
    }
}
