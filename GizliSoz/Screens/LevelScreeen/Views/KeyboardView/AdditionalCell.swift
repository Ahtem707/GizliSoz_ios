//
//  AdditionalCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 31.12.2022.
//

import UIKit

class AdditionalCellBuilder {
    
    struct Layouts {
        let backImageMultiplayer: CGFloat = 0.8
        let counterEdge = UIEdgeInsets(all: -5)
        let counterSize = CGSize(width: 22, height: 22)
    }
    
    struct Appearance {
        let backgroundNormal = AppColor.Cell.normal
        let backgroundSelected = AppColor.Cell.select
        let hintEnableImage = AppImage.lampEnable
        let hintDisableImage = AppImage.lampDisable
        let hammerEnableImage = AppImage.hammerEnable
        let hammerDisableImage = AppImage.hammerDisable
        let wordsImage = AppImage.word
        let soundEnableImage = AppImage.speakerEnable
        let soundDisableImage = AppImage.speakerDisable
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

final class AdditionalCell: AppView {
    
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
                tipViewText = "Ihtar".translate
            case .hammer:
                backImage.image = appearance.hammerEnableImage
            case .bonusWords:
                backImage.image = appearance.wordsImage
            case .sound:
                backImage.image = appearance.soundEnableImage
            }
        }
    }
    
    func longTap() {
        guard let type = type else { return }
        let text: String
        switch type {
        case .hint: text = AppText.LevelScreen.hint
        case .hammer: text = AppText.LevelScreen.hammer
        case .bonusWords: text = AppText.LevelScreen.bonusWords
        case .sound: text = AppText.LevelScreen.sound
        }
        
        if let translateText = text.translate {
            showTipView("\(text)\n\(translateText)")
        } else {
            showTipView("\(text)")
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
        NSLayoutConstraint.activate([
            backImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: layout.backImageMultiplayer),
            backImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: layout.backImageMultiplayer)
        ])
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
