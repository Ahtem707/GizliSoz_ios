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
        setupContents()
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
    
    private func setupContents() {
        title = viewModel.getViewTitle()
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
    func levelComplete() {
        let alert = UIAlertController(
            title: "Успех",
            message: "Вы открыли все слова",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Понятно",
                style: .default,
                handler: { _ in alert.dismiss(animated: true) }
            )
        )
        present(alert, animated: true)
    }
}
