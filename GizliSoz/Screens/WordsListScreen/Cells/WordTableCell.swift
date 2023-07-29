//
//  WordTableCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 02.04.2023.
//

import UIKit

struct WordCellLayout {
    let centerContainer = UIEdgeInsets(vertical: 16, horizontal: 0)
    let horizontalSpacer = CGFloat(16)
    let verticalSpacer = CGFloat(16)
    let soundButtonSize = CGSize(width: 30, height: 30)
}

struct WordCellAppearance {
    let wordLabelFont = AppFont.font(style: .bold, size: 16)
    let translateLabelFont = AppFont.font(style: .regular, size: 14)
    let wordLabelColor = AppColor.Text.primary
    let translateLabelColor = AppColor.Text.secondary
    let soundButtonDisabledImage = AppImage.soundDisable
    let soundButtonEnabledImage = AppImage.soundEnable
}

struct WordCellData {
    let id: Int
    let word: String
    let translate: String
    let isHaveSound: Bool
    let isMasked: Bool
    
    static let `default` = WordCellData(id: 0, word: "", translate: "", isHaveSound: false, isMasked: false)
}

final class WordCell: UITableViewCell {
    
    var data: WordCellData! {
        didSet {
            wordLabel.text = data.isMasked ? makeTextMasked(text: data.word) : data.word
            translateLabel.text = data.translate
            soundButton.isHidden = !data.isHaveSound
            soundButton.isUserInteractionEnabled = data.isHaveSound && !data.isMasked
            let image = !data.isMasked ? appearance.soundButtonEnabledImage : appearance.soundButtonDisabledImage
            soundButton.setImage(image, for: .normal)
        }
    }
    
    var didSelectSound: VoidClosure?
    
    private let centerContainer = UIView()
    private let wordLabel = UILabel()
    private let translateLabel = UILabel()
    private let soundButton = UIButton()
    
    private let layouts = WordCellLayout()
    private let appearance = WordCellAppearance()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        centerContainer.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        translateLabel.translatesAutoresizingMaskIntoConstraints = false
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(centerContainer)
        centerContainer.addSubview(wordLabel)
        centerContainer.addSubview(translateLabel)
        contentView.addSubview(soundButton)
        
        soundButton.addTarget(self, action: #selector(soundButtonAction), for: .touchUpInside)
        
        centerContainer.pinToSuperview(edges: [.top, .left, .bottom], insets: layouts.centerContainer)
        wordLabel.pinToSuperview(edges: [.top, .left, .right])
        translateLabel.pinTop(toBottom: wordLabel, spacing: layouts.verticalSpacer)
        translateLabel.pinToSuperview(edges: [.left, .right, .bottom])
        soundButton.pinToSuperview(edges: [.right], insets: layouts.centerContainer)
        soundButton.pinLeft(toRight: centerContainer, spacing: layouts.horizontalSpacer)
        soundButton.pinCenter(to: centerContainer, of: .vertical)
        soundButton.pin(size: layouts.soundButtonSize)
        
        backgroundColor = .clear
        wordLabel.font = appearance.wordLabelFont
        wordLabel.textColor = appearance.wordLabelColor
        translateLabel.font = appearance.translateLabelFont
        translateLabel.textColor = appearance.translateLabelColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    @objc private func soundButtonAction(_ sender: UIButton) {
        didSelectSound?()
    }
    
    private func makeTextMasked(text: String) -> String {
        return String(repeating: AppConstants.maskedChar, count: text.count)
    }
}
