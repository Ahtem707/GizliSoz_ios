//
//  LevelsCollectionCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import UIKit

extension LevelsCollectionCell {
    struct Layouts {
        let viewSize = CGSize(width: 50, height: 50)
        let viewRadius: CGFloat = 8
        let labelEdges = UIEdgeInsets(all: 0)
        let subIconEdges = UIEdgeInsets(all: 0)
        let subIconSize = CGSize(width: 20, height: 20)
    }
    
    struct Appearance {
        let viewBackgroundNormal = AppColor.Cell.normal
        let viewBackgroundSelected = AppColor.Cell.select
        let viewBackgroundLock = AppColor.Cell.disabled
        let labelFont = AppFont.font(style: .regular, size: 40)
        let labelColorNormal = AppColor.Text.primary
        let labelColorLock = AppColor.Text.disable
        let subIcon = AppImage.lock
    }
}

class LevelsCollectionCell: UICollectionViewCell {
    
    // MARK: - Private variable
    private let layouts = Layouts()
    private let appearance = Appearance()
    private let label = UILabel()
    private let subIcon = UIImageView()
    
    static var identifier: String {
        String(describing: self)
    }
    
    var type: CellType = .normal {
        didSet {
            updateType(type)
        }
    }

    var text: String = "" {
        didSet {
            setText(text)
        }
    }
    
    // MARK: - Life cycle functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayouts()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupLayouts()
        setupAppearance()
    }
}

// MARK: - Private functions
extension LevelsCollectionCell {
    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        subIcon.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        addSubview(subIcon)
    }
    
    private func setupLayouts() {
        pin(size: layouts.viewSize)
        layer.cornerRadius = layouts.viewRadius
        label.pinToSuperview(edges: .all, insets: layouts.labelEdges)
        subIcon.pinToSuperview(edges: [.right, .bottom], insets: layouts.subIconEdges)
        subIcon.pin(size: layouts.subIconSize)
    }
    
    private func setupAppearance() {
        backgroundColor = appearance.viewBackgroundNormal
        label.textAlignment = .center
        label.font = appearance.labelFont
        label.textColor = appearance.labelColorNormal
        subIcon.image = appearance.subIcon
    }
    
    private func updateType(_ type: CellType) {
        switch type {
        case .normal:
            backgroundColor = appearance.viewBackgroundNormal
            label.textColor = appearance.labelColorNormal
            subIcon.isHidden = true
        case .selected:
            backgroundColor = appearance.viewBackgroundSelected
            label.textColor = appearance.labelColorNormal
            subIcon.isHidden = true
        case .locked:
            backgroundColor = appearance.viewBackgroundLock
            label.textColor = appearance.labelColorLock
            subIcon.isHidden = false
        }
    }
    
    private func setText(_ text: String) {
        label.text = text
    }
}
