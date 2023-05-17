//
//  Label.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 16.05.2023.
//

import UIKit
import EasyTipView

extension EasyTipView {
    static let appPreferences: EasyTipView.Preferences = {
        var preferences = EasyTipView.globalPreferences
        preferences.drawing.shadowRadius = 2
        preferences.drawing.shadowOpacity = 0.75
        preferences.drawing.shadowColor = UIColor.black
        preferences.drawing.backgroundColor = UIColor.gray
        return preferences
    }()
}

extension UIView: EasyTipViewDelegate {
    fileprivate static var tipView: EasyTipView?
    
    func showTipView(_ text: String) {
        UIView.tipView = EasyTipView(text: text, preferences: EasyTipView.appPreferences, delegate: self)
        UIView.tipView?.show(forView: self)
    }
    
    public func easyTipViewDidTap(_ tipView: EasyTipView) {}
    
    public func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        UIView.tipView = nil
    }
}

extension UILabel {
    func addTipView() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction))
        addGestureRecognizer(tap)
    }
    
    @objc private func longTapAction(_ selector: UIView) {
        if UIView.tipView == nil {
            guard let text = text?.translate else { return }
            
            self.showTipView(text)
        }
    }
}

extension UIButton {
    static func swizzle() {
        let originalSelector = #selector(UIButton.setTitle)
        let swizzledSelector = #selector(UIButton._tracked_setTitle)
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
    
    @objc private func _tracked_setTitle(_ title: String?, for state: UIControl.State) {
        setupTooltipView()
        _tracked_setTitle(title, for: state)
    }
    
    private func setupTooltipView() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction))
        addGestureRecognizer(tap)
    }
    
    @objc private func longTapAction(_ selector: UIView) {
        if UIView.tipView == nil {
            guard let text = titleLabel?.text?.translate else { return }
            
            self.showTipView(text)
        }
    }
}

extension UINavigationController {
    static func swizzleNavigationController() {
        let originalSelectorPush = #selector(UINavigationController.pushViewController)
        let swizzledSelectorPush = #selector(UINavigationController._tracked_pushViewController)
        let originalMethodPush = class_getInstanceMethod(self, originalSelectorPush)
        let swizzledMethodPush = class_getInstanceMethod(self, swizzledSelectorPush)
        method_exchangeImplementations(originalMethodPush!, swizzledMethodPush!)
    }

    @objc private func _tracked_pushViewController(_ viewController: UIViewController?, animated: Bool) {
        UIView.tipView?.dismiss()
        UIView.tipView = nil
        _tracked_pushViewController(viewController, animated: animated)
    }
}

extension UIViewController {
    static func swizzleViewController() {
        let originalSelectorPresent = #selector(UIViewController.present)
        let swizzledSelectorPresent = #selector(UIViewController._tracked_present)
        let originalMethodPresent = class_getInstanceMethod(self, originalSelectorPresent)
        let swizzledMethodPresent = class_getInstanceMethod(self, swizzledSelectorPresent)
        method_exchangeImplementations(originalMethodPresent!, swizzledMethodPresent!)
    }
    
    @objc private func _tracked_present(_ viewControllerToPresent: UIViewController?, animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.tipView?.dismiss()
        UIView.tipView = nil
        _tracked_present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
