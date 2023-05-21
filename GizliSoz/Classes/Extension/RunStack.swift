//
//  RunStack.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 15.05.2023.
//

import Foundation

/// Класс позволяет запускать блоки кода в последовательности добавления
class RunStack {
    typealias Completion = () -> Void
    private var maxRuns: Int?
    private var runStack: [Completion] = []
    
    /// Инициализатор
    /// - Parameter maxRuns: максимальное количество вызываемых функций
    init(maxRuns: Int? = nil) {
        self.maxRuns = maxRuns
    }
    
    var count: Int {
        return runStack.count
    }
    
    /// Добавить новую функцию в стек
    func add(completion: @escaping Completion) {
        if let maxRuns = maxRuns, runStack.count >= maxRuns { return }
        runStack.append(completion)
        if runStack.count == 1 {
            completion()
        }
    }
    
    /// Переход ко следующей функции стека
    func next() {
        if !runStack.isEmpty {
            runStack.removeFirst()
            runStack.first?()
        }
    }
}
