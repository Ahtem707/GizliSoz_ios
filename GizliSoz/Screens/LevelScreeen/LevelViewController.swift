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
        crossView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backImage)
        view.addSubview(crossView)
        view.addSubview(keyboardView)
    }
    
    private func setupLayouts() {
        backImage.pinToSuperview()
        crossView.pinToSuperview(edges: .top, insets: layouts.crossViewEdge, safeArea: true)
        crossView.pinToSuperview(edges: [.left, .right], insets: layouts.crossViewEdge)
        crossView.pinRatio()
        keyboardView.pinToSuperview(edges: [.bottom, .left, .right], insets: layouts.keyboardViewEdge)
        keyboardView.pinRatio(value: -50)
    }
    
    private func setupAppearance() {
        backImage.image = appearance.backImage
    }
    
    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        view.addGestureRecognizer(tap)
    }
    
    private func levelsFinished() {
        AlertsFactory.makeLevelsFinished(
            cancelAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
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
    
    func levelComplete() {
        let status = AppStorage.levelUp()
        AlertsFactory.makeLevelComplete(
            yesAction: { [weak self] in
                if status {
                    self?.viewModel.initialize()
                } else {
                    self?.levelsFinished()
                }
            },
            cancelAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
    }
}
