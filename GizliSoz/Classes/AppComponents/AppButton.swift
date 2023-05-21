//
//  AppButton.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 21.05.2023.
//

import UIKit

final class AppButton: UIButton {
    var tipViewText: String? {
        didSet {
            self.isUserInteractionEnabled = true
            let tap = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction))
            self.addGestureRecognizer(tap)
        }
    }
    
    @objc private func longTapAction(_ selector: UIView) {
        guard let text = tipViewText else { return }
        showTipView(text)
    }
}
