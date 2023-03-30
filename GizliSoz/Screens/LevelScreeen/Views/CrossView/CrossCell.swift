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
        let cellNormalBack: UIColor = AppColor.Cell.normal
        let cellSelectBack: UIColor = AppColor.Cell.select
        let textFont: UIFont = AppFont.font(style: .regular, size: 36)
        let textFillerColor: UIColor = AppColor.Text.secondary
        let textNormalColor: UIColor = AppColor.Text.primary
        let animationTime: TimeInterval = 1
    }
    
    enum State {
        case hidden
        case phantom
        case show
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
    
    private let container = UIView()
    private let label = UILabel()
    
    // MARK: - public variable
    var delegate: CrossCellDelegate?
    var wordsId: [Int]!
    var x: Int!
    var y: Int!
    var text: String! {
        didSet {
            label.text = text.uppercased()
        }
    }
    var state: CrossCellBuilder.State = .hidden {
        didSet {
            switch state {
            case .hidden:
                label.isHidden = true
            case .phantom:
                label.isHidden = false
                label.textColor = appearance.textFillerColor
            case .show:
                label.isHidden = false
                label.textColor = appearance.textNormalColor
                cellSelectedAnimate()
            }
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
        container.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(container)
        container.addSubview(label)
        label.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        addGestureRecognizer(tap)
    }
    
    private func setupLayouts() {
        container.layer.cornerRadius = layout.cellCorner
        container.pinToSuperview()
        label.pinToSuperview()
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        container.backgroundColor = appearance.cellNormalBack
        label.font = appearance.textFont
        label.textColor = appearance.textNormalColor
        label.textAlignment = .center
    }
    
    @objc private func viewTap() {
        delegate?.didSelect(crossCell: self)
    }
    
    /// Анимированное выделение ячейки
    private func cellSelectedAnimate() {
        roundingAnimation(value: true) {
            self.roundingAnimation(value: false)
        }
    }
    
    /// Анимированное выделение или нормализация ячейки
    /// - Parameters:
    ///   - value: если true - то загругляется и выделяется
    ///   - completion: Замыкание завершение анимации
    private func roundingAnimation(value: Bool, completion: VoidClosure? = nil) {
        UIView.animate(withDuration: appearance.animationTime, animations: {
            if value {
                self.container.backgroundColor = self.appearance.cellSelectBack
                self.container.layer.cornerRadius = self.container.frame.size.width / 2
            } else {
                self.container.backgroundColor = self.appearance.cellNormalBack
                self.container.layer.cornerRadius = self.layout.cellCorner
            }
        },
        completion: { _ in
            completion?()
        })
    }
}
