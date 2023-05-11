//
//  UIView.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import UIKit

extension UIView {
    /// Установка закругления углов для компонента
    /// - Parameters:
    ///   - corners: Углы закругления
    ///   - radius: Значение закругления
    func setRoundCorners(corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if corners.contains(.layerMinXMinYCorner) {
                cornerMask.insert(.topLeft)
            }
            if corners.contains(.layerMaxXMinYCorner) {
                cornerMask.insert(.topRight)
            }
            if corners.contains(.layerMinXMaxYCorner) {
                cornerMask.insert(.bottomLeft)
            }
            if corners.contains(.layerMaxXMaxYCorner) {
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: cornerMask,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
