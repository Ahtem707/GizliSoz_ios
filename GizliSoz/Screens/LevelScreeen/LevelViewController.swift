//
//  LevelViewController.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.11.2022.
//

import UIKit

final class LevelViewController: BaseViewController {
    
    // MARK: - Public variables
    var viewModel: LevelViewModelProtocol!
    var layouts: LevelBuilder.Layouts!
    var appearance: LevelBuilder.Appearances!
    
    // MARK: - Private variables
    private let backImage = UIImageView()
    private let contentView = UIView()
    let crossView = CrossView()
    let keyboardView = KeyboardView()
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupLayouts()
        setupAppearance()
        setupAction()
    }
}

// MARK: - Setup private functions
extension LevelViewController {
    private func setupSubviews() {
        backImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        crossView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backImage)
        view.addSubview(contentView)
        contentView.addSubview(crossView)
        contentView.addSubview(keyboardView)
    }
    
    private func setupLayouts() {
        backImage.pinToSuperview()
        contentView.pinToSuperview(edges: .all, insets: layouts.contentViewEdge, safeArea: true)
        crossView.pinToSuperview(edges: .top, insets: layouts.crossViewEdge)
        crossView.pinToSuperview(edges: [.left, .right], insets: layouts.crossViewEdge)
        keyboardView.pinTop(toBottom: crossView, spacing: layouts.keyboardViewEdge.top)
        keyboardView.pinToSuperview(edges: [.bottom, .left, .right], insets: layouts.keyboardViewEdge)
        keyboardView.pinRatio(value: layouts.keyboardViewRatio)
    }
    
    private func setupAppearance() {
        backImage.image = appearance.backImage
    }
    
    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Actions
extension LevelViewController {
    @objc private func viewTap() {
        viewModel.turnOffHammerFromView()
    }
}

// MARK: - LevelViewControllerDelegate
extension LevelViewController: LevelViewControllerDelegate {
    func setTitle(_ text: String) {
        title = text
    }
    
    func presentVC(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .pageSheet
        present(viewController, animated: true)
    }
    
    func levelsFinished() {
        AlertsFactory.makeLevelsFinished(
            cancelAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
    }
}
