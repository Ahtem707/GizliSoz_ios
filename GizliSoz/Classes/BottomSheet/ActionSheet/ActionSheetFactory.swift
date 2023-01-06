//
//  ActionSheetFactory.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import UIKit

final class ActionSheetFactory {
    
    private static let rootViewController: UIViewController? = {
        if #available(iOS 15, *) {
            let scenes = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene })
            let keyWindow = scenes.first?.windows.first { $0.isKeyWindow }
            return keyWindow?.rootViewController
        } else {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.rootViewController
        }
    }()
    
    static func makeDinamic(dataSource: [ActionSheetModel]) {
        let vc = ActionSheetViewController()
        vc.dataSource = dataSource
        vc.modalPresentationStyle = .overFullScreen
        rootViewController?.present(vc, animated: false)
    }
}
