//
//  SettingsValueCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 17.05.2023.
//

import UIKit

extension SettingsValueCell {
    struct Layouts {
        let titleLabelEdges = UIEdgeInsets(all: 10)
        let valueLabelEdges = UIEdgeInsets(all: 10)
    }
    
    struct Appearance {
        let titleLabelFont = AppFont.font(style: .regular, size: 22)
        let titleLabelColor = AppColor.Text.white
        let valueLabelFont = AppFont.font(style: .regular, size: 18)
        let valueLabelColor = AppColor.Text.white
    }
}

final class SettingsValueCell: UITableViewCell {
    
    // MARK: - Private variable
    private let layouts = Layouts()
    private let appearance = Appearance()
    private let titlelLabel = AppLabel()
    private let valueLabel = UILabel()
    private let button = UIButton()
    
    // MARK: - Public variable
    var title: String = "" {
        didSet {
            titlelLabel.text = title
            titlelLabel.tipViewText = title.translate
        }
    }
    
    var value: String = "" {
        didSet {
            valueLabel.text = value
        }
    }
    
    var action: (() -> Void)?
        
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
extension SettingsValueCell {
    private func setupSubviews() {
        titlelLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titlelLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(button)
        
        button.addTarget(self, action: #selector(valueAction), for: .touchUpInside)
    }
    
    private func setupLayouts() {
        titlelLabel.pinToSuperview(edges: .left, insets: layouts.titleLabelEdges)
        titlelLabel.pinCenterToSuperview(of: .vertical)
        valueLabel.pinToSuperview(edges: .right, insets: layouts.valueLabelEdges)
        valueLabel.pinCenterToSuperview(of: .vertical)
        button.pin(to: valueLabel)
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        titlelLabel.font = appearance.titleLabelFont
        titlelLabel.textColor = appearance.titleLabelColor
        valueLabel.font = appearance.valueLabelFont
        valueLabel.textColor = appearance.valueLabelColor
    }
    
    @objc private func valueAction(_ selector: UIButton) {
        action?()
    }
}
