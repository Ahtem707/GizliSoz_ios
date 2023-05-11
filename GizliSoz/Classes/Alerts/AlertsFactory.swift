//
//  AlertsFactory.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import UIKit

class AlertsFactory {
    
    static func makeLevelComplete(yesAction: VoidClosure?, cancelAction: VoidClosure?) {
        let alert = UIAlertController(
            title: "Maşalla!",
            message: "Siz er sözlerni açtiñiz",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Devam eterim",
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                    yesAction?()
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Bugünge yeter",
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                    cancelAction?()
                }
            )
        )
        rootViewController?.present(alert, animated: true)
    }
    
    static func makeLevelsFinished(cancelAction: VoidClosure?) {
        let alert = UIAlertController(
            title: "Oyun soñuna çıqti",
            message: "Kelecek seviyeler bitti.\nDevam etmege istemeysiñiz?",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Yahşı",
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                    cancelAction?()
                }
            )
        )
        rootViewController?.present(alert, animated: true)
    }
}

extension AlertsFactory {
    typealias VoidClosure = () -> Void
    
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
}
