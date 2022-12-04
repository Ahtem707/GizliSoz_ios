//
//  CrossCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import UIKit

class KeyboardCellBuilder {
    
    struct Layouts {
        
    }
    
    struct Appearance {
        let cellBackNormal: UIColor = AppColor.Cell.normal
        let cellBackSelect: UIColor = AppColor.Cell.select
        let textFont: UIFont = AppFont.font(style: .regular, size: 50)
        let textColor: UIColor = AppColor.Text.primary
    }
}

final class KeyboardCell: UIView {
    
    typealias B = KeyboardCellBuilder
    
    // MARK: - Private variable
    private let layout = B.Layouts()
    private let appearance = B.Appearance()
    
    private let label = UILabel()
    private let backImage = UIImageView()
    
    var text: String! {
        didSet {
            label.text = text
        }
    }
    var image: UIImage! {
        didSet {
            backImage.image = image
        }
    }
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? appearance.cellBackSelect : appearance.cellBackNormal
        }
    }
    
    // MARK: - Initialize
    init() {
        super.init(frame: .zero)
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

// MARK: - Private functionc
extension KeyboardCell {
    private func setupSubviews() {
        backImage.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backImage)
        addSubview(label)
    }
    
    private func setupLayouts() {
        backImage.pinCenterToSuperview(of: .vertical)
        backImage.pinCenterToSuperview(of: .horizontal)
        label.pinCenterToSuperview(of: .horizontal)
        label.pinCenterToSuperview(of: .vertical)
    }
    
    private func setupAppearance() {
        self.backgroundColor = appearance.cellBackNormal
        label.font = appearance.textFont
        label.textColor = appearance.textColor
    }
}
