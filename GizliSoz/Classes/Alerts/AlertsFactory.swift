//
//  AlertsFactory.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import UIKit

class AlertsFactory {
    
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
    
    static func makeLogicError() {
        let alert = UIAlertController(
            title: "Bağışlañız, bir hata oldi",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Yahşı",
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                }
            )
        )
        rootViewController?.present(alert, animated: true)
    }
    
    static func makeServerError() {
        let alert = UIAlertController(
            title: "Mobil uyğulamada hata oldi",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Yahşı",
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
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
