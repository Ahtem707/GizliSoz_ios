//
//  KeyboardGestureRecognizer.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 04.12.2022.
//

import UIKit

// MARK: - Кастомный обработчик нажатий для клавиатуры
class KeyboardGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        self.state = .changed
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.state = .ended
    }
}
