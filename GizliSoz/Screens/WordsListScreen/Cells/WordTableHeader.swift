//
//  WordTableHeader.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 02.04.2023.
//

import UIKit

struct WordHeaderLayout {
    let labelEdges = UIEdgeInsets(vertical: 16, horizontal: 0)
}

struct WordHeaderAppearance {
    let labelFont = AppFont.font(style: .bold, size: 30)
    let labelColor = AppColor.Text.primary
}

struct WordHeaderData {
    let text: String
    
    static let `default` = WordHeaderData(text: "")
}

final class WordHeader: UIView {
    
    private let label = UILabel()
    
    var data: WordHeaderData! {
        didSet {
            label.text = data.text
        }
    }
    
    private let layouts = WordHeaderLayout()
    private let appearance = WordHeaderAppearance()
    
    init() {
        super.init(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        label.pinToSuperview(insets: layouts.labelEdges)
        label.font = appearance.labelFont
        label.textColor = appearance.labelColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
}
