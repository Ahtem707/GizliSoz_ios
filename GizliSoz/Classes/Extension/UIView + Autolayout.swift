//
//  UIView + Autolayout.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import UIKit

@resultBuilder
public enum ConstraintsBuilder {
    public static func buildBlock(_ constraints: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
        constraints.flatMap { $0 }
    }

    public static func buildIf(_ constraints: [NSLayoutConstraint]?) -> [NSLayoutConstraint] {
        constraints ?? []
    }

    public static func buildExpression(_ constraint: NSLayoutConstraint?) -> [NSLayoutConstraint] {
        guard let constraint = constraint else { return [] }
        return [constraint]
    }

    public static func buildExpression(_ constraint: NSLayoutConstraint) -> [NSLayoutConstraint] {
        [constraint]
    }
}

public extension NSLayoutConstraint {
    
    @discardableResult
    func setIdentifier(_ identifier: String) -> Self {
        self.identifier = identifier
        return self
    }
    
    @discardableResult
    func activate() -> Self {
        self.priority = .required
        self.isActive = true
        return self
    }
    
    @discardableResult
    func disable() -> Self {
        self.isActive = false
        return self
    }
        
    @discardableResult
    func setPriority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
    
    @discardableResult
    func setConstant(_ constant: CGFloat) -> Self {
        self.constant = constant
        return self
    }
    
//    @discardableResult
//    func animate(_ duration: TimeInterval) -> Self {
//        UIView.animate(withDuration: duration) {
//            self.firstItem?.superview?.layer.layoutIfNeeded()
//        }
//        return self
//    }
//
//    func action<Key: Equatable>(_ bag: LayoutBag<Key>, key: Key) {
//
//        self.isActive = false
//        bag.append(self, key: key)
//    }
}

//public class LayoutBag<Key: Equatable> {
//
//    var keys: [Key] = []
//    var animation: [TimeInterval] = []
//    var constrains: [NSLayoutConstraint] = []
//
//    func append(_ constrains: NSLayoutConstraint, key: Key) {
//        self.keys.append(key)
//        self.constrains.append(constrains)
//    }
//
//    func on(_ key: Key) {
//        self.keys.enumerated()
//            .filter { $1 == key }
//            .forEach { index, _ in
//                self.constrains[index].isActive = true
//            }
//        UIView.animate(withDuration: duration) {
//            self.firstItem?.superview?.layer.layoutIfNeeded()
//        }
//    }
//
//    func off(_ key: Key) {
//        self.keys.enumerated()
//            .filter { $1 == key }
//            .forEach { index, _ in
//                self.constrains[index].isActive = false
//            }
//    }
//}

public extension Array where Element == NSLayoutConstraint {
    
    init(@ConstraintsBuilder _ builder: () -> [NSLayoutConstraint]) {
        self = builder()
    }
    
    @discardableResult
    func activate() -> [NSLayoutConstraint] {
        self.forEach { $0.activate() }
        return self
    }
    
    @discardableResult
    func disable() -> Self {
        self.forEach { $0.disable() }
        return self
    }
    
    @discardableResult
    func setPriority(_ priority: UILayoutPriority) -> [NSLayoutConstraint] {
        self.forEach { $0.setPriority(priority) }
        return self
    }
    
    @discardableResult
    func setConstant(_ constant: CGFloat) -> Self {
        self.forEach { $0.setConstant(constant) }
        return self
    }
}


extension UIView {
    
    /// Привязка правой точки View к левой точке указанного View
    /// - Parameters:
    ///   - view: к левой точке которого привязываем
    ///   - spacing: расстояние между элементами
    @discardableResult
    func pinRight(
        toLeft view: UIView,
        spacing: CGFloat = 0
    ) -> NSLayoutConstraint {
        assert(self.superview == view.superview, "Use only for views with common superview")
        return self.rightAnchor.constraint(equalTo: view.leftAnchor, constant: spacing).activate()
    }
    
    /// Привязка правой точки View к правой точке указанного View
    /// - Parameters:
    ///   - view: к левой точке которого привязываем
    ///   - spacing: расстояние между элементами
    @discardableResult
    func pinRight(
        toRight view: UIView,
        spacing: CGFloat = 0
    ) -> NSLayoutConstraint {
        assert(self.superview == view.superview, "Use only for views with common superview")
        return self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: spacing).activate()
    }
    
    /// Привязка левой точки View к левой точке указанного View
    /// - Parameters:
    ///   - view: к левой точке которого привязываем
    ///   - spacing: расстояние между элементами
    @discardableResult
    func pinLeft(
        toLeft view: UIView,
        spacing: CGFloat = 0
    ) -> NSLayoutConstraint {
        assert(self.superview == view.superview, "Use only for views with common superview")
        return self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: spacing).activate()
    }
    
    /// Привязка левой точки View к правой точке указанного View
    /// - Parameters:
    ///   - view: к правой точке которого привязываем
    ///   - spacing: расстояние между элементами
    @discardableResult
    func pinLeft(
        toRight view: UIView,
        spacing: CGFloat = 0
    ) -> NSLayoutConstraint {
        assert(self.superview == view.superview, "Use only for views with common superview")
        return self.leftAnchor.constraint(equalTo: view.rightAnchor, constant: spacing).activate()
    }
    
    /// Привязка верхней точки View к верхней точке указанного View
    /// - Parameters:
    ///   - view: к верху которого привязываем
    ///   - spacing: расстояние между элементами
    @discardableResult
    func pinTop(
        toTop view: UIView,
        spacing: CGFloat = 0
    ) -> NSLayoutConstraint {
        assert(self.superview == view.superview, "Use only for views with common superview")
        return self.topAnchor.constraint(equalTo: view.topAnchor, constant: spacing).activate()
    }
    
    /// Привязка верхней точки View к нижней точке указанного View
    /// - Parameters:
    ///   - view: к низу которого привязываем
    ///   - spacing: расстояние между элементами
    @discardableResult
    func pinTop(
        toBottom view: UIView,
        spacing: CGFloat = 0
    ) -> NSLayoutConstraint {
        assert(self.superview == view.superview, "Use only for views with common superview")
        return self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: spacing).activate()
    }
    
    /// Привязка нижней точки View к верхней точке указанного View
    /// - Parameters:
    ///   - view: к верху которого привязываем
    ///   - spacing: расстояние между элементами
    @discardableResult
    func pinBottom(
        toTop view: UIView,
        spacing: CGFloat = 0
    ) -> NSLayoutConstraint {
        assert(self.superview == view.superview, "Use only for views with common superview")
        return self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -spacing).activate()
    }
    
    /// Привязка нижней точки View к нижней точке указанного View
    /// - Parameters:
    ///   - view: к низу которого привязываем
    ///   - spacing: расстояние между элементами
    @discardableResult
    func pinBottom(
        toBottom view: UIView,
        spacing: CGFloat = 0
    ) -> NSLayoutConstraint {
        assert(self.superview == view.superview, "Use only for views with common superview")
        return self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: spacing).activate()
    }
    
    /// Установка и активация констрейнтов относительно родительской View
    /// - Parameters:
    ///   - edges: что привязываем, по умолчанию все стороны
    ///   - insets: отступы, по умолчанию отступы = 0
    ///   - safeArea: учитывать SafeArea или нет, по умолчанию не учитвается
    @discardableResult
    func pinToSuperview(
        edges: UIRectEdge = .all,
        insets: UIEdgeInsets = .zero,
        safeArea: Bool = false
    ) -> [NSLayoutConstraint] {
        if self.superview == nil {
            assertionFailure("View must have superview")
        }
        return self.pin(to: self.superview!, edges: edges, insets: insets, safeArea: safeArea)
    }
    
    
    /// Установка и активация констрейнтов относительно указанной оси
    /// - Parameters:
    ///   - view: к какой View привязываем
    ///   - axis: ось координат
    ///   - offset: offset
    @discardableResult
    func pinCenter(
        to view: UIView,
        of axis: NSLayoutConstraint.Axis,
        offset: CGPoint = .zero
    ) -> NSLayoutConstraint {
        switch axis {
        case .horizontal:
            return self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x).activate()
        case .vertical:
            return self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y).activate()
        @unknown default:
            fatalError()
        }
    }
    
    /// Установка и активация констрейнтов относительно указанной оси для superview
    /// - Parameters:
    ///   - view: к какой View привязываем
    ///   - axis: ось координат
    ///   - offset: offset
    @discardableResult
    func pinCenterToSuperview(
        of axis: NSLayoutConstraint.Axis,
        offset: CGPoint = .zero
    ) -> NSLayoutConstraint {
        if self.superview == nil {
            assertionFailure("View must have superview")
        }
        return self.pinCenter(to: self.superview!, of: axis, offset: offset)
    }
    
    /// Установка и активация констрйента высоты
    /// - Parameters:
    ///   - height: высота
    @discardableResult
    func pin(height: CGFloat) -> NSLayoutConstraint {
        return self.heightAnchor.constraint(equalToConstant: height).activate()
    }
    
    /// Установка и активация констрйента ширины
    /// - Parameters:
    ///   - width: ширина
    @discardableResult
    func pin(width: CGFloat) -> NSLayoutConstraint {
        return self.widthAnchor.constraint(equalToConstant: width).activate()
    }
    
    /// Установка и активация констрйентов для размеров View
    /// - Parameters:
    ///   - size: устанавливаемые размеры
    @discardableResult
    func pin(size: CGSize) -> [NSLayoutConstraint] {
        return [
            self.widthAnchor.constraint(equalToConstant: size.width),
            self.heightAnchor.constraint(equalToConstant: size.height)
        ].activate()
    }
    
    /// Установка зависимости соотношения сторон
    @discardableResult
    func pinRatio(value: CGFloat = 0) -> NSLayoutConstraint {
        return self.widthAnchor.constraint(equalTo: self.heightAnchor, constant: value).activate()
    }
    
    /// Установка и активация констрейнтов относительно родительской View
    /// - Parameters:
    ///   - view: относительно какой View устанавливаем констрейнты
    ///   - edges: что привязываем, по умолчанию все стороны
    ///   - insets: отступы, по умолчанию отступы = 0
    ///   - safeArea: учитывать SafeArea или нет, по умолчанию не учитвается
    @discardableResult
    func pin(
        to view: UIView,
        edges: UIRectEdge = .all,
        insets: UIEdgeInsets = .zero,
        safeArea: Bool = false
    ) -> [NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            let constraints: [NSLayoutConstraint] = .init { () -> [NSLayoutConstraint] in
                if edges.contains(.left) {
                        self.leadingAnchor.constraint(equalTo: safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, constant: insets.left)
                }
                if edges.contains(.top) {
                    
                        self.topAnchor.constraint(equalTo: safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: insets.top)
                }
                if edges.contains(.right) {
                    (safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor).constraint(equalTo: self.trailingAnchor, constant: insets.right)
                }
                if edges.contains(.bottom) {
                    (safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor).constraint(equalTo: self.bottomAnchor, constant: insets.bottom)
                }
            }
            return constraints.activate()
        } else {
            let constraints: [NSLayoutConstraint] = .init { () -> [NSLayoutConstraint] in
                if edges.contains(.left) {
                    self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left)
                }
                if edges.contains(.top) {
                    self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top)
                }
                if edges.contains(.right) {
                    view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: insets.right)
                }
                if edges.contains(.bottom) {
                    view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom)
                }
            }
            return constraints.activate()
        }
    }
}
