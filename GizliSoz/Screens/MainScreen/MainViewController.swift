//
//  MainViewController.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import UIKit

final class MainViewController: BaseViewController {
    
    // MARK: - Public variables
    var viewModel: MainViewModelProtocol!
    var layouts: MainBuilder.Layouts!
    var appearance: MainBuilder.Appearances!
    
    // MARK: - Private variables
    private let backImage = UIImageView()
    private let logoImage = UIImageView()
    private let stackContainer = UIView()
    private let stack = UIStackView()
    private let levelButton = AppButton()
    private let settingButton = AppButton()
    private let startButton = AppButton()
    
    enum Constraint {
        case logo
        case stack
    }
    var constrainBag: [Constraint : ()->Void] = [:]
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupLayouts()
        setupAppearance()
        setupContents()
        setupAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.constrainBag[.logo]?()
            self.constrainBag[.stack]?()
        }
    }
}

// MARK: - Setup functions
extension MainViewController {
    private func setupSubviews() {
        backImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        levelButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backImage)
        view.addSubview(logoImage)
        view.addSubview(stackContainer)
        stackContainer.addSubview(stack)
        stack.addArrangedSubview(levelButton)
        stack.addArrangedSubview(settingButton)
        stack.addArrangedSubview(startButton)
    }
    
    private func setupLayouts() {
        backImage.pinToSuperview()
        logoImage.pinCenterToSuperview(of: .horizontal)
        let logoConstrain = logoImage.pinCenterToSuperview(of: .vertical)
        constrainBag[.logo] = {
            logoConstrain.setConstant(self.layouts.logoOffset)
            UIView.animate(withDuration: self.layouts.logoImageAnimate) {
                self.logoImage.superview?.layoutIfNeeded()
            }
        }
        
        stackContainer.pinToSuperview(edges: [.left, .right], insets: layouts.stackEdge)
        stackContainer.pinToSuperview(edges: .bottom, insets: layouts.stackEdge).setPriority(.defaultHigh)
        let stackConstrain = stackContainer.pinToSuperview(edges: .bottom, insets: layouts.stackEdge).setConstant(layouts.stackOffset)
        constrainBag[.stack] = {
            stackConstrain.disable()
            UIView.animate(withDuration: self.layouts.logoImageAnimate) {
                self.stackContainer.superview?.layoutIfNeeded()
            }
        }
        
        stack.pinToSuperview()
        stack.axis = .vertical
        stack.spacing = layouts.stackSpacing
        
        levelButton.pin(height: layouts.secondButtonHeight)
        settingButton.pin(height: layouts.secondButtonHeight)
        startButton.pin(height: layouts.primaryButtonHeight)
        levelButton.layer.cornerRadius = layouts.buttonsCorner
        settingButton.layer.cornerRadius = layouts.buttonsCorner
        startButton.layer.cornerRadius = layouts.buttonsCorner
    }
    
    private func setupAppearance() {
        backImage.image = appearance.backImage
        logoImage.image = appearance.logoImage

        levelButton.backgroundColor = appearance.secondaryButtonBack
        settingButton.backgroundColor = appearance.secondaryButtonBack
        startButton.backgroundColor = appearance.primaryButtonBack
        levelButton.setImage(appearance.levelButtonImage, for: .normal)
        settingButton.setImage(appearance.settingsButtonImage, for: .normal)
        levelButton.titleLabel?.font = appearance.secondaryButtonFont
        settingButton.titleLabel?.font = appearance.secondaryButtonFont
        startButton.titleLabel?.font = appearance.primaryButtonFont
        levelButton.setTitleColor(appearance.secondaryButtonColor, for: .normal)
        settingButton.setTitleColor(appearance.secondaryButtonColor, for: .normal)
        startButton.setTitleColor(appearance.primaryButtonColor, for: .normal)
    }
    
    private func setupContents() {
        levelButton.setTitle(AppText.MainScreen.levels, for: .normal)
        settingButton.setTitle(AppText.MainScreen.settings, for: .normal)
        startButton.setTitle(AppText.MainScreen.start, for: .normal)
        
        levelButton.tipViewText = levelButton.titleLabel?.text?.translate
        settingButton.tipViewText = settingButton.titleLabel?.text?.translate
        startButton.tipViewText = startButton.titleLabel?.text?.translate
    }
    
    private func setupAction() {
        levelButton.addTarget(self, action: #selector(levelButtonAction), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
    }
}

// MARK: - Actions
extension MainViewController {
    @objc private func levelButtonAction(_ sender: UIButton) {
        navigationController?.pushViewController(LevelsBuilder.start(), animated: true)
    }
    
    @objc private func settingsButtonAction(_ sender: UIButton) {
        navigationController?.pushViewController(SettingsBuilder.start(), animated: true)
    }

    @objc private func startButtonAction(_ sender: UIButton) {
        navigationController?.pushViewController(LevelBuilder.start(), animated: true)
    }
}

// MARK: - MainViewControllerDelegate
extension MainViewController: MainViewControllerDelegate {
    
}
