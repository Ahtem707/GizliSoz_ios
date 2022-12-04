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
}
