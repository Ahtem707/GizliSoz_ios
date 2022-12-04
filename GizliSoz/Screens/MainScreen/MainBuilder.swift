//
//  MainBuilder.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import UIKit

final class MainBuilder {
    
    static func start() -> UIViewController {
        let viewController = MainViewController()
        let viewModel = MainViewModel()
        viewModel.delegate = viewController
        viewController.viewModel = viewModel
        viewModel.initialize()
        viewController.layouts = Layouts()
        viewController.appearance = Appearances()
        return viewController
    }
    
    struct Layouts {
        let logoOffset: CGFloat = -60
        let logoImageAnimate: CGFloat = 0.6
        let stackEdge: UIEdgeInsets = UIEdgeInsets(vertical: 30, horizontal: 10)
        let stackOffset: CGFloat = -300
        let stackSpacing: CGFloat = 10
        let primaryButtonHeight: CGFloat = 70
        let secondButtonHeight: CGFloat = 50
        let buttonsCorner: CGFloat = 20
        let buttonsImageSpacer: CGFloat = 20
    }
    
    struct Appearances {
        let backImage: UIImage = AppImage.appBackground
        let logoImage: UIImage = AppImage.appLogo
        let levelButtonImage: UIImage = AppImage.level
        let settingsButtonImage: UIImage = AppImage.settings
        let primaryButtonBack: UIColor = AppColor.Button.backGreen
        let secondaryButtonBack: UIColor = AppColor.Button.backWhite
        let primaryButtonFont: UIFont = AppFont.font(style: .regular, size: 40)
        let secondaryButtonFont: UIFont = AppFont.font(style: .regular, size: 24)
        let primaryButtonColor: UIColor = AppColor.Button.white
        let secondaryButtonColor: UIColor = AppColor.Button.blue
    }
}
