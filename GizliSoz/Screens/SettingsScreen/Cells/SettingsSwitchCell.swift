//
//  SettingsSwitchCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import UIKit

extension SettingsSwitchCell {
    struct Layouts {
        let labelEdges = UIEdgeInsets(all: 10)
        let switchViewEdges = UIEdgeInsets(all: 10)
    }
    
    struct Appearance {
        let labelFont = AppFont.font(style: .regular, size: 22)
        let labelColor = AppColor.Text.white
    }
}

final class SettingsSwitchCell: UITableViewCell {
    
    // MARK: - Private variable
    private let layouts = Layouts()
    private let appearance = Appearance()
    private let label = UILabel()
    private let switchView = UISwitch()
    
    // MARK: - Public variable
    var title: String = "" {
        didSet {
            label.text = title
        }
    }
    var isEnable: Bool = false {
        didSet {
            switchView.isOn = isEnable
        }
    }
    var action: ((_ value: Bool) -> Void)?
        
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
extension SettingsSwitchCell {
    private func setupSubviews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        switchView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        contentView.addSubview(switchView)
        
        switchView.addTarget(self, action: #selector(switchViewAction), for: .valueChanged)
    }
    
    private func setupLayouts() {
        label.pinToSuperview(edges: .left, insets: layouts.labelEdges)
        label.pinCenterToSuperview(of: .vertical)
        switchView.pinToSuperview(edges: .right, insets: layouts.switchViewEdges)
        switchView.pinCenterToSuperview(of: .vertical)
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        label.font = appearance.labelFont
        label.textColor = appearance.labelColor
    }
    
    @objc private func switchViewAction(_ sender: UISwitch) {
        action?(sender.isOn)
    }
}
