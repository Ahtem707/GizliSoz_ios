//
//  CrossCell.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import UIKit

class CrossCellBuilder {
    
    struct Layouts {
        let cellCorner: CGFloat = 8
    }
    
    struct Appearance {
        let cellBack: UIColor = AppColor.Cell.normal
        let textFont: UIFont = AppFont.font(style: .regular, size: 40)
        let textColor: UIColor = AppColor.Text.primary
    }
}

protocol CrossCellDelegate {
    func didSelect(crossCell: CrossCell)
}

final class CrossCell: UIView {
    
    typealias B = CrossCellBuilder
    
    // MARK: - Private variable
    private let layout = B.Layouts()
    private let appearance = B.Appearance()
    
    private let label = UILabel()
    
    // MARK: - public variable
    var delegate: CrossCellDelegate?
    var wordsId: [Int]!
    var x: Int!
    var y: Int!
    var text: String! {
        didSet {
            label.text = text
        }
    }
    var isShow: Bool = false {
        didSet {
            label.isHidden = !isShow
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

// MARK: - Private methods
extension CrossCell {
    private func setupSubviews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        addGestureRecognizer(tap)
    }
    
    private func setupLayouts() {
        self.layer.cornerRadius = layout.cellCorner
        label.pinToSuperview()
    }
    
    private func setupAppearance() {
        self.backgroundColor = appearance.cellBack
        label.font = appearance.textFont
        label.textColor = appearance.textColor
        label.textAlignment = .center
    }
    
    @objc private func viewTap() {
        delegate?.didSelect(crossCell: self)
    }
}
