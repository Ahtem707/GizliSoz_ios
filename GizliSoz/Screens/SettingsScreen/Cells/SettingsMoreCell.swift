//
//  SettingsMoreCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import UIKit

extension SettingsMoreCell {
    struct Layouts {
        let labelEdges = UIEdgeInsets(all: 10)
        let buttonEdges = UIEdgeInsets(all: 10)
        let buttonSize = CGSize(width: 25, height: 25)
    }
    
    struct Appearance {
        let labelFont = AppFont.font(style: .regular, size: 22)
        let labelColor = AppColor.Text.white
        let buttonImage = AppImage.arrowRight
    }
}

final class SettingsMoreCell: UITableViewCell {
    
    // MARK: - Private variable
    private let layouts = Layouts()
    private let appearance = Appearance()
    private let label = AppLabel()
    private let button = UIButton()
    
    // MARK: - Public variable
    var title: String = "" {
        didSet {
            label.text = title
            label.tipViewText = title.translate
        }
    }
    var action: (()->Void)?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
extension SettingsMoreCell {
    private func setupSubviews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        contentView.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func setupLayouts() {
        label.pinToSuperview(edges: .left, insets: layouts.labelEdges)
        label.pinCenterToSuperview(of: .vertical)
        button.pinToSuperview(edges: .right, insets: layouts.buttonEdges)
        button.pin(size: layouts.buttonSize)
        button.pinCenterToSuperview(of: .vertical)
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        label.font = appearance.labelFont
        label.textColor = appearance.labelColor
        button.setImage(appearance.buttonImage, for: .normal)
    }
    
    @objc private func buttonAction(_ selector: UIButton) {
        action?()
    }
}
