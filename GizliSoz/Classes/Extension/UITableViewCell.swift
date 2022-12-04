//
//  UITableViewCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import UIKit

extension UITableViewCell {
    
    static func fromView(_ view: UIView) -> UITableViewCell {
        let cell = UITableViewCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(view)
        view.pinToSuperview()
        return cell
    }
}
