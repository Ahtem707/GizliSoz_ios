//
//  KeyboardLogic.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 04.12.2022.
//

import UIKit

final class KeyboardLogic {
    
    /// Преобразует полярные координаты в декартовые
    /// - Parameters:
    ///   - radius: Радиус
    ///   - corner: Угол поворота от первой четверти против часовой стрелки
    /// - Returns: Возвращает декартовые координаты
    static func getPosition(radius: CGFloat, corner: CGFloat) -> CGPoint {
        let x = radius * cos(corner * CGFloat.pi / 180)
        let y = radius * sin(corner * CGFloat.pi / 180)
        
        return CGPoint(x: x, y: y)
    }
    
    /// Строит круг и возвращает точки на нем
    /// - Parameters:
    ///   - radius: Радиус круга
    ///   - count: Количество точек
    ///   - cornerOffset: Смещение точек против часовой стрелки
    /// - Returns: Возвращает массив координат точек на круге
    static func getPositions(radius: CGFloat, count: Int, cornerOffset: CGFloat = 0) -> [CGPoint] {
        return (0..<count).map { index in
            let corner = CGFloat(index * 360 / count) + cornerOffset
            let point = getPosition(radius: radius, corner: corner)
            
            return point
        }
    }
    
    /// Строит точки для дополнительных кнопок
    /// - Parameters:
    ///   - radius: Радиус круга
    /// - Returns: Возвращает массив координат точек на круге
    static func get4AdditionalPositions(radius: CGFloat) -> [CGPoint] {
        return (1...4).map { index in
            var corner: CGFloat = 180
            if index == 1 {
                corner += 45
            } else if index == 2 {
                corner += 65
            } else if index == 3 {
                corner += 115
            }else {
                corner += 135
            }
            return getPosition(radius: radius, corner: corner)
        }
    }
    
    /// Определяет входит ли точка в пределы view
    /// - Parameters:
    ///   - view: входная view
    ///   - point: точка проверки
    /// - Returns: Возвращает булевое значение, true если точка входит во view
    static func hoverZone(view: UIView, point: CGPoint, local: Bool = false) -> Bool {
        let rect = local ? view.bounds : view.frame
        
        if view.layer.cornerRadius != 0 {
            // Для круга
            let centerX = rect.origin.x + rect.size.width / 2
            let centerY = rect.origin.y + rect.size.height / 2
            let radius = rect.size.width / 2
            
            return pow(point.x - centerX, 2) + pow(point.y - centerY, 2) <= pow(radius, 2)
        } else {
            // Для квадрата
            let xs = rect.origin.x
            let xe = rect.origin.x + rect.size.width
            let ys = rect.origin.y
            let ye = rect.origin.y + rect.size.height
            
            return (xs...xe).contains(point.x) && (ys...ye).contains(point.y)
        }
    }
    
    /// Расчет параметров круговой клавиатуры
    /// - Parameters:
    ///   - view: родительская view
    ///   - count: количество ячеек
    ///   - diameter: входящий диаметр
    ///   - cellSize: входящий размер ячейки
    ///   - viewCenter: входящий центр родителькой view
    static func calcKeyboardParameter(
        _ view: UIView,
        count: Int,
        diameter: inout CGFloat,
        cellSize: inout CGFloat,
        viewCenter: inout CGPoint
    ) {
        let width = view.bounds.width
        let height = view.bounds.height
        let sideRatio = sin(CGFloat.pi / CGFloat(count))
        let firstStep = 4 + 3 * sideRatio
        let secondStep = 3 + 12 * sideRatio
        
        diameter = width * firstStep / secondStep
        cellSize = (diameter * sideRatio) / (sideRatio + 1)
        viewCenter = CGPoint(x: width/2, y: height/2 + cellSize/4)
    }
}
