//
//  UITableView.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import UIKit

extension UITableView {
    /// Зарегистрировать ячейку по идентификатору типа класса
    /// - Parameter cellClass: Переддаем тип класса
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String(describing: cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    /// Зарегистрировать xib ячейку по идентификатору типа класса
    /// - Parameter cellClass: Переддаем тип класса
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    /// Получить ячейку по идентификатору типа класса
    /// - Returns: Возвращает  требуемый тип ячейки
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)") as! T
    }
    
    /// Получить ячейку по идентификатору типа класса с дополнительной позицией
    /// - Returns: Возвращает  требуемый тип ячейки
    func dequeue<T: UITableViewCell>(cellForRowAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
}

extension UITableViewCell {
    
    static func fromView(_ view: UIView) -> UITableViewCell {
        let cell = UITableViewCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: cell.topAnchor),
            view.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            view.leftAnchor.constraint(equalTo: cell.leftAnchor),
            view.rightAnchor.constraint(equalTo: cell.rightAnchor),
        ])
        return cell
    }
}
