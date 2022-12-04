//
//  UIEdgeInsets.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import UIKit

public extension UIEdgeInsets {
    
    init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self = .init(top: top, left: leading, bottom: bottom, right: trailing)
    }

    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self = .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    init(all: CGFloat = 0) {
        self = .init(top: all, left: all, bottom: all, right: all)
    }
}
