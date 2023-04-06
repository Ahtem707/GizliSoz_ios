//
//  KeyboardView.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 20.11.2022.
//

import UIKit

class KeyboardViewBuilder {
    
    struct Layouts {
        let lineWidth: CGFloat = 10
    }
    
    struct Appearance {
        let shuffleImage: UIImage = AppImage.shake
        let shuffleTranslucent: CGFloat = 0.6
        let lineColor: UIColor = AppColor.Keyboard.line
        let animateDuration: CGFloat = 0.5
    }
    
    struct Input {
        let chars: [String]
    }
}

final class KeyboardView: UIView {
    typealias B = KeyboardViewBuilder
    
    // MARK: - Public variable
    var viewModel: LevelKeyboardViewModelProtocol?
    
    // MARK: - Private variable
    private var input: B.Input?
    private let layouts = B.Layouts()
    private let appearance = B.Appearance()
    
    private let linesView = UIView()
    private var shuffleCell = KeyboardCell()
    private var cells: [KeyboardCell] = []
    private var selectedCells: [KeyboardCell] = []
    private var additionalButtons: [AdditionalCell] = []
    
    private var lastPoint: CGPoint?
    private var cellSize: CGFloat = 0
    private var diameter: CGFloat = 0
    private var viewCenter: CGPoint = CGPoint()
    private var cellsPositions: [CGPoint] = []
    private var additionalPositions: [CGPoint] = []
    private var isSetupLayouts: Bool = false
    private var isShuffleAnimation: Bool = false
    
    // MARK: - Lifecycle functions
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
    }
}

// MARK: - Private functions
extension KeyboardView {
    /// Обновление позиции ячеек
    private func setupLayouts() {
        guard !isSetupLayouts else { return }
        isSetupLayouts = true
        setParameters()
        setZeroPosition()
        animationStart()
    }
    
    /// Установить базовые параметры
    private func setParameters() {
        
        KeyboardLogic.calcKeyboardParameter(
            self,
            count: cells.count,
            diameter: &diameter,
            cellSize: &cellSize,
            viewCenter: &viewCenter
        )
        
        // Инициализация позиций ячеек
        cells.shuffle()
        cellsPositions = KeyboardLogic.getPositions(radius: diameter/2, count: cells.count)
        
        additionalPositions = KeyboardLogic.get4AdditionalPositions(radius: diameter/2 + cellSize)
    }
    
    /// Установить стартовую позицию для всех ячейек
    private func setZeroPosition() {
        shuffleCell.frame.size.width = cellSize
        shuffleCell.frame.size.height = cellSize
        shuffleCell.layer.cornerRadius = cellSize / 2
        shuffleCell.frame.origin.x = viewCenter.x - cellSize / 2
        shuffleCell.frame.origin.y = viewCenter.y - cellSize / 2
        
        for i in 0..<cells.count {
            cells[i].frame.size.width = cellSize
            cells[i].frame.size.height = cellSize
            cells[i].layer.cornerRadius = cellSize / 2
            cells[i].frame.origin.x = viewCenter.x - cellSize / 2
            cells[i].frame.origin.y = viewCenter.y - cellSize / 2
        }
        
        for i in 0..<additionalButtons.count {
            let cellSize = self.cellSize * 0.7
            additionalButtons[i].frame.size.width = cellSize
            additionalButtons[i].frame.size.height = cellSize
            additionalButtons[i].layer.cornerRadius = cellSize / 2
            additionalButtons[i].frame.origin.x = viewCenter.x - cellSize / 2
            additionalButtons[i].frame.origin.y = viewCenter.y - cellSize / 2
        }
    }
    
    /// Запускает анимированные кейсы
    private func animationStart() {
        shuffleButtonState(.show) {
            self.showCharsCells()
        }
    }
    
    private enum State {
        case hide
        case show
        case translucent
    }
    
    /// Изменяет состояние отображения кнопки перемешнивания
    /// - Parameter value: Тип состояния
    private func shuffleButtonState(_ value: State, completion: (()->Void)? = nil) {
        let alpha: CGFloat
        switch value {
        case .hide: alpha = 0
        case .show: alpha = 1
        case .translucent: alpha = appearance.shuffleTranslucent
        }
        
        UIView.animate(
            withDuration: appearance.animateDuration,
            animations: { self.shuffleCell.alpha = alpha },
            completion: { _ in completion?() }
        )
    }
    
    /// Анимированное отображение ячеек
    private func showCharsCells() {
        UIView.animate(
            withDuration: appearance.animateDuration,
            animations: { self.cells.forEach { $0.alpha = 1 } },
            completion: { _ in self.moveCharsCells() }
        )
    }
    
    /// Изменить позицию для ячеек
    private func moveCharsCells() {
        isShuffleAnimation = true
        UIView.animate(
            withDuration: appearance.animateDuration,
            animations: {
                for i in 0..<self.cells.count {
                    let nowX = self.viewCenter.x + self.cellsPositions[i].x - self.cellSize / 2
                    let nowY = self.viewCenter.y + self.cellsPositions[i].y - self.cellSize / 2

                    self.cells[i].alpha = 1
                    self.cells[i].frame.size.width = self.cellSize
                    self.cells[i].frame.size.height = self.cellSize
                    self.cells[i].layer.cornerRadius = self.cellSize / 2
                    self.cells[i].frame.origin.x = nowX
                    self.cells[i].frame.origin.y = nowY
                }
                
                for i in 0..<self.additionalButtons.count {
                    let cellSize = self.cellSize * 0.7
                    let nowX = self.viewCenter.x + self.additionalPositions[i].x - cellSize / 2
                    let nowY = self.viewCenter.y + self.additionalPositions[i].y - cellSize / 2
                    
                    self.additionalButtons[i].frame.size.width = cellSize
                    self.additionalButtons[i].frame.size.height = cellSize
                    self.additionalButtons[i].layer.cornerRadius = cellSize / 2
                    self.additionalButtons[i].frame.origin.x = nowX
                    self.additionalButtons[i].frame.origin.y = nowY
                }
                
            },
            completion: { _ in
                self.isShuffleAnimation = false
                self.shuffleToBack()
            }
        )
    }
    
    private func shuffleToBack() {
        sendSubviewToBack(shuffleCell)
    }
}

// MARK: - GestureRecognizer
extension KeyboardView {
    
    /// Инициализация обработчика нажатий
    private func gestureInit() {
        let like = KeyboardGestureRecognizer(target: self, action: #selector(handleGesture))
        addGestureRecognizer(like)
    }
    
    /// Обработчик нажатий
    @objc private func handleGesture(_ gesture: KeyboardGestureRecognizer) {
        
        // Получить координаты нажатия
        let point = gesture.location(in: self)
        
        // Блокировка при выходе за границы клавиатуры
        guard KeyboardLogic.hoverZone(view: self, point: point, local: true) else {
            defaultState()
            shuffleButtonState(.show)
            return
        }
        
        // Выключить режим молотка
        if gesture.state == .began {
            viewModel?.turnOffHammerFromKeyboardView()
        }
        
        // Обработать нажатие для кнопки перемешивания и выйти
        if gesture.state == .began && KeyboardLogic.hoverZone(view: shuffleCell, point: point) {
            shuffleHandlePan()
            return
        }
        
        // Обработать нажатие для дополнительных кнопок и выйти
        if gesture.state == .began {
            for cell in additionalButtons {
                if KeyboardLogic.hoverZone(view: cell, point: point) {
                    additionalHandlePan(cell.type)
                    return
                }
            }
        }
        
        // Получить список не выбранных ячеек
        let notSelectedCells = cells.filter { !selectedCells.contains($0) }
        
        // Обработать нажатия и перетаскивание для выбора и создания линий
        switch gesture.state {
        case .began:
            guard lastPoint == nil else { return }
            for cell in notSelectedCells {
                if KeyboardLogic.hoverZone(view: cell, point: point) {
                    shuffleButtonState(.translucent)
                    cell.isSelected = true
                    selectedCells.append(cell)
                    drawLine(cell.center, cell.center)
                    lastPoint = cell.center
                    break
                }
            }
        case .changed:
            guard lastPoint != nil else { return }
            
            for cell in notSelectedCells {
                if KeyboardLogic.hoverZone(view: cell, point: point) {
                    cell.isSelected = true
                    selectedCells.append(cell)
                    updateLastLine(lastPoint, cell.center)
                    drawLine(lastPoint, cell.center)
                    lastPoint = cell.center
                    break
                } else {
                    updateLastLine(lastPoint, point)
                }
            }
        case .ended:
            guard lastPoint != nil else { return }
            wordComplete()
            defaultState()
            shuffleButtonState(.show)
        default: break
        }
    }
    
    /// Перемешивает и обновляет позиции ячеек
    private func shuffleHandlePan() {
        guard !isShuffleAnimation else { return }
        cells.shuffle()
        cellsPositions = KeyboardLogic.getPositions(radius: diameter/2, count: cells.count)
        moveCharsCells()
    }
    
    private func additionalHandlePan(_ type: AdditionalCellBuilder.Types) {
        switch type {
        case .hint:
            viewModel?.hintHandle()
        case .hammer:
            viewModel?.hammerHandle()
        case .bonusWords:
            viewModel?.bonusWords()
        case .sound:
            viewModel?.soundHandle()
        }
    }
    
    /// Завершение составление слова
    private func wordComplete() {
        let word = selectedCells.compactMap { $0.text }
        viewModel?.wordComplete(word: word)
    }
    
    /// Вернуть все переменные в изначальное состояние
    private func defaultState() {
        clearLines()
        lastPoint = nil
        selectedCells.forEach { $0.isSelected = false }
        selectedCells.removeAll()
    }
}

// MARK: - Рисование линии
extension KeyboardView {
    /// Рисует линию по координатам
    /// - Parameters:
    ///   - from: Начальная точка
    ///   - to: Конечная точка
    private func drawLine(_ from: CGPoint?, _ to: CGPoint) {
        guard let from = from else { return }
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        
        linePath.move(to: from)
        linePath.addLine(to: to)
        line.path = linePath.cgPath
        line.lineWidth = layouts.lineWidth
        line.strokeColor = appearance.lineColor.cgColor
        linesView.layer.addSublayer(line)
    }
    
    /// Обновляет последнюю нарисованную линию
    /// - Parameters:
    ///   - from: Начальная точка
    ///   - to: Конечная точка
    private func updateLastLine(_ from: CGPoint?, _ to: CGPoint) {
        guard let from = from else { return }
        linesView.layer.sublayers?.removeLast()
        drawLine(from, to)
    }
    
    private func clearLines() {
        linesView.layer.sublayers?.removeAll()
    }
}

// MARK: - LevelKeyboardViewDelegate
extension KeyboardView: LevelKeyboardViewDelegate {
    func initialize(input: B.Input) {
        self.input = input
        
        // Настройка ячейки перемешивания
        shuffleCell.alpha = 0
        shuffleCell.image = appearance.shuffleImage
        
        // Генерация ячеек букв
        input.chars.forEach { char in
            let cell = KeyboardCell()
            cell.text = char
            cell.alpha = 0
            cells.append(cell)
        }
        
        // Генерация ячеек дополнительных кнопок
        let additionalCells = AdditionalCellBuilder.Types.allCases
        additionalCells.forEach { button in
            let cell = AdditionalCell()
            cell.type = button
            cell.counter = nil
            cell.isActive = false
            additionalButtons.append(cell)
        }
        
        // Добавление ячеек на view
        addSubview(shuffleCell)
        cells.forEach { cell in
            insertSubview(cell, at: 0)
        }
        additionalButtons.forEach { cell in
            insertSubview(cell, at: 0)
        }
        insertSubview(linesView, at: 0)
        
        // Инициализация обработчика
        gestureInit()
    }
    
    func setAdditionalStatus(type: AdditionalCellBuilder.Types, isActive: Bool, counter: String?) {
        let button = additionalButtons.first { $0.type == type }
        button?.isActive = isActive
        button?.counter = counter
    }
    
    func setAdditionalSelected(type: AdditionalCellBuilder.Types, isSelected: Bool) {
        additionalButtons.first { $0.type == type }?.isSelected = isSelected
    }
    
    func clear() {
        subviews.forEach { $0.removeFromSuperview() }
        isSetupLayouts = false
        cells.removeAll()
        selectedCells.removeAll()
        additionalButtons.removeAll()
    }
}
