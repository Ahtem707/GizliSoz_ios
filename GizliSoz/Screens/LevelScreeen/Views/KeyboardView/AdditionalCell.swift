//
//  AdditionalCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 31.12.2022.
//

import UIKit

class AdditionalCellBuilder {
    
    struct Layouts {
        let counterEdge = UIEdgeInsets(all: -5)
        let counterSize = CGSize(width: 25, height: 25)
    }
    
    struct Appearance {
        let backgroundNormal = AppColor.Cell.normal
        let backgroundSelected = AppColor.Cell.select
        let hintEnableImage = AppImage.hintEnable
        let hintDisableImage = AppImage.hintDisable
        let hammerEnableImage = AppImage.hammerEnable
        let hammerDisableImage = AppImage.hammerDisable
        let wordsImage = AppImage.words
        let soundEnableImage = AppImage.soundEnable
        let soundDisableImage = AppImage.soundDisable
        let counterBackground = AppColor.Keyboard.counter
        let counterLabelFont = AppFont.font(style: .regular, size: 10)
        let counterLabelColor = AppColor.Text.primary
    }
    
    enum Types: CaseIterable {
        case hint
        case hammer
        case bonusWords
        case sound
    }
}

final class AdditionalCell: UIView {
    
    typealias B = AdditionalCellBuilder
    
    // MARK: - Private variable
    private let layout = B.Layouts()
    private let appearance = B.Appearance()
    
    private let backImage = UIImageView()
    private let counterView = UIView()
    private let counterLabel = UILabel()
    
    var type: B.Types! {
        didSet {
            guard let type = type else { return }
            switch type {
            case .hint:
                backImage.image = appearance.hintEnableImage
            case .hammer:
                backImage.image = appearance.hammerEnableImage
            case .bonusWords:
                backImage.image = appearance.wordsImage
            case .sound:
                backImage.image = appearance.soundEnableImage
            }
        }
    }
    var counter: String? {
        didSet {
            if let counter = counter, counter != "", counter != "0" {
                counterView.isHidden = false
                counterLabel.text = counter
            } else {
                counterView.isHidden = true
            }
        }
    }
    var isActive: Bool = false {
        didSet {
            guard let type = type else { return }
            switch type {
            case .hint:
                backImage.image = isActive ? appearance.hintEnableImage : appearance.hintDisableImage
            case .hammer:
                backImage.image = isActive ? appearance.hammerEnableImage : appearance.hammerDisableImage
            case .bonusWords:
                backImage.image = isActive ? appearance.wordsImage : appearance.wordsImage
            case .sound:
                backImage.image = isActive ? appearance.soundEnableImage : appearance.soundDisableImage
            }
        }
    }
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? appearance.backgroundSelected : appearance.backgroundNormal
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
extension AdditionalCell {
    private func setupSubviews() {
        backImage.translatesAutoresizingMaskIntoConstraints = false
        counterView.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backImage)
        addSubview(counterView)
        counterView.addSubview(counterLabel)
    }
    
    private func setupLayouts() {
        backImage.pinCenterToSuperview(of: .vertical)
        backImage.pinCenterToSuperview(of: .horizontal)
        counterView.pinToSuperview(edges: [.top, .right], insets: layout.counterEdge)
        counterView.pin(size: layout.counterSize)
        counterView.layer.cornerRadius = layout.counterSize.width / 2
        counterLabel.pinCenterToSuperview(of: .vertical)
        counterLabel.pinCenterToSuperview(of: .horizontal)
    }
    
    private func setupAppearance() {
        backgroundColor = appearance.backgroundNormal
        counterView.backgroundColor = appearance.counterBackground
        counterLabel.font = appearance.counterLabelFont
        counterLabel.textColor = appearance.counterLabelColor
    }
}
