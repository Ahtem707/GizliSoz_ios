//
//  AnimateStack.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 01.12.2022.
//

import UIKit

class AnimateStack {
    
    typealias Closure = () -> Void
    typealias ClosureBool = (Bool) -> Void
    
    struct Animate {
        let duration: TimeInterval
        let animation: Closure
        let completion: ClosureBool?
    }
    
    private weak var delegate: AnyObject?
    private var animationArray: [Animate] = []
    private let autostart: Bool
    
    init(_ delegate: AnyObject, autostart: Bool = true) {
        self.delegate = delegate
        self.autostart = autostart
    }
    
    /// Добавить новое замыкание-анимацию
    func add(
        with duration: TimeInterval,
        animation: @escaping Closure,
        completion: ClosureBool? = nil
    ) {
        animationArray.append(
            Animate(
                duration: duration,
                animation: animation,
                completion: completion
            )
        )
        if autostart && animationArray.count == 1 {
            execute()
        }
    }
    
    /// Ручной запуск анимации
    func start() {
        if autostart {
            assertionFailure("Установлен автостарт, ручной запуск блокируется")
            return
        }
        execute()
    }
    
    /// Замыкание что запускается при завершении всей анимации
    var finalize: ClosureBool?
    
    /// Выполнение анимации
    private func execute() {
        if delegate == nil {
            animationArray.removeAll()
        }
        guard let animate = animationArray.first else { return }
        UIView.animate(
            withDuration: animate.duration,
            animations: animate.animation,
            completion: { value in
                self.animationArray.removeFirst()
                animate.completion?(value)
                if !self.animationArray.isEmpty {
                    self.execute()
                } else {
                    self.finalize?(value)
                }
            }
        )
    }
}
