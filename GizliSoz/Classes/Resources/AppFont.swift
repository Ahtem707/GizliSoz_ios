//
//  AppFont.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import Foundation

import UIKit

enum SFProDisplayStyle: String {
    case black = "SFProDisplay-Black"
    case bold = "SFProDisplay-Bold"
    case light = "SFProDisplay-Light"
    case medium = "SFProDisplay-Medium"
    case regular = "SFProDisplay-Regular"
    case semibold = "SFProDisplay-Semibold"
}

class AppFont: UIFont {
    
    static func font(style: SFProDisplayStyle, size: CGFloat) -> UIFont {
        UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
