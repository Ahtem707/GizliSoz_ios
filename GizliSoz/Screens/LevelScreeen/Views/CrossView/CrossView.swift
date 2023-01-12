//
//  CrossView.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 07.11.2022.
//

import UIKit

class CrossViewBuilder {
    
    struct Layouts {
        let cellSpacer: CGFloat = 2
    }
    
    struct Appearance {
        let animateDuration: CGFloat = 0.5
    }
    
    struct Input {
        let size: Int
        let words: [Word]
    }
    
    struct Word {
        let id: Int
        let word: String
        let chars: [CellData]
    }
    
    struct CellData: Hashable {
        let x: Int
        let y: Int
        let char: String
    }
}

final class CrossView: UIView {
    
    typealias B = CrossViewBuilder
    
    // MARK: - Public variable
    var viewModel: LevelCrossViewModelProtocol?
    
    // MARK: - Private variable
    private var input: B.Input?
    private let layouts = B.Layouts()
    private let appearance = B.Appearance()
    
    private var cells: [CrossCell] = []
    private var openByPressingPermission: Bool = false
    
    // MARK: - Lifecycle functions
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutUpdate()
    }
}

// MARK: - Private functions
extension CrossView {
    /// Обновление позиции ячеек
    private func layoutUpdate() {
        
        // Получаем размер матрицы
        let cellWidthCount = CGFloat(cells.reduce(0, { $0 > $1.x ? $0 : $1.x }) + 1)
        let cellHeightCount = CGFloat(cells.reduce(0, { $0 > $1.y ? $0 : $1.y }) + 1)
        let screenW = bounds.width
        let screenH = bounds.height
        
        let allCellSpacerWidth = layouts.cellSpacer * (cellWidthCount - 1)
        let allCellSpacerHeight = layouts.cellSpacer * (cellHeightCount - 1)
        
        let allCellWidth = screenW - allCellSpacerWidth
        let allCellHeight = screenH - allCellSpacerHeight
        
        let cellSizeWidth = allCellWidth / cellWidthCount
        
        // Определить параметры ячеек
        let cellSize: CGFloat
        if cellSizeWidth * cellHeightCount + allCellSpacerWidth < screenH {
            cellSize = allCellWidth / cellWidthCount
        } else {
            cellSize = allCellHeight / cellHeightCount
        }
        
        let crossWidthOffset = cellSize * cellWidthCount + layouts.cellSpacer * (cellWidthCount-1)
        let widthOffset = (screenW - crossWidthOffset) / 2
        
        // Изменить позицию для ячеек
        cells.forEach { cell in
            cell.frame.size.width = cellSize
            cell.frame.size.height = cellSize
            cell.frame.origin.x = widthOffset + (cellSize + layouts.cellSpacer) * CGFloat(cell.x)
            cell.frame.origin.y = (cellSize + layouts.cellSpacer) * CGFloat(cell.y)
        }
        
        // Отобразить ячейки
        UIView.animate(withDuration: appearance.animateDuration) {
            self.cells.forEach { $0.alpha = 1 }
        }
    }
    
    /// Проверка открытых слов
    private func checkWords() {
        if cells.reduce(true, { $0 && $1.isShow }) {
            viewModel?.wordsCompleted()
        }
    }
}

// MARK: - CrossCellDelegate
extension CrossView: CrossCellDelegate {
    func didSelect(crossCell: CrossCell) {
        guard openByPressingPermission else { return }
        
        // Получаем массив еще не открытых ячеек
        let closeCells = cells.filter { !$0.isShow }
        
        // Возвращаем false при отсутсвии закрытых ячеек
        guard !closeCells.isEmpty else { return }
        
        // Проверка присутствия ячейки в списке закрытых
        guard closeCells.contains(crossCell) else { return }
        
        // Открытие ячейки и вызов действия при успешности
        crossCell.isShow = true
        openByPressingPermission = false
        viewModel?.openByPressingClosure()
        
        // Проверка состояния открытых слов
        checkWords()
    }
}

extension Array where Element == CrossCell {
    fileprivate func contains(cellData: CrossViewBuilder.CellData) -> Bool {
        self.contains { cell in
            return cell.text == cellData.char
            && cell.x == cellData.x
            && cell.y == cellData.y
        }
    }
    
    fileprivate func first(cellData: CrossViewBuilder.CellData) -> Element? {
        self.first { cell in
            return cell.text == cellData.char
            && cell.x == cellData.x
            && cell.y == cellData.y
        }
    }
}

// MARK: - LevelCrossViewDelegate
extension CrossView: LevelCrossViewDelegate {
    /// Инициализация
    /// - Parameter input: Входные данные
    func initialize(input: B.Input) {
        self.input = input
        
        // Генерация ячеек
        for word in input.words {
            for cellData in word.chars {
                if !cells.contains(cellData: cellData) {
                    let cell = CrossCell()
                    cell.delegate = self
                    cell.wordsId = [word.id]
                    cell.x = cellData.x
                    cell.y = cellData.y
                    cell.text = cellData.char
                    cell.alpha = 0
                    cells.append(cell)
                } else {
                    let cell = cells.first(cellData: cellData)
                    cell?.wordsId.append(word.id)
                }
            }
        }
        
        // Добавление ячеек на view
        cells.forEach { cell in
            addSubview(cell)
        }
    }
    
    func openWord(word: String) -> Int? {
        guard let input = self.input else { return nil }
        
        // Получить идентификатор слова
        guard let wordId = input.words.first(where: { $0.word == word })?.id else { return nil }
        
        // Получить ячейки которые входят в искомое слово
        let cells = cells.filter { $0.wordsId.contains(wordId) }
        
        // Отобразить текст ячеек искомых ячеек
        cells.forEach { $0.isShow = true }
        
        // Проверка состояния открытых слов
        checkWords()
        
        return wordId
    }
    
    func openRandom() -> Bool {
        
        // Получаем массив еще не открытых ячеек
        let closeCells = cells.filter { !$0.isShow }
        
        // Возвращаем false при отсутсвии закрытых ячеек
        guard !closeCells.isEmpty else { return false }
        
        // Получаем случайную ячейку
        let cellIndex = Int.random(in: 0..<closeCells.count)
        let cell = closeCells[cellIndex]
        
        // Открываем ячейку и возвращаем успешный результат
        cell.isShow = true
        
        // Проверка состояния открытых слов
        checkWords()
        
        return true
    }
    
    func openByPressing(valueIfNeeded: Bool?) -> Bool {
        if let value = valueIfNeeded {
            openByPressingPermission = value
            return value
        } else {
            openByPressingPermission = !openByPressingPermission
            return openByPressingPermission
        }
    }
    
    func clear() {
        subviews.forEach { $0.removeFromSuperview() }
        cells.removeAll()
    }
}
