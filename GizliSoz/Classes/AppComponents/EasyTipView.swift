//
//  Label.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 16.05.2023.
//

import UIKit
import EasyTipView

extension EasyTipView {
    fileprivate static let appPreferences: EasyTipView.Preferences = {
        var preferences = EasyTipView.globalPreferences
        preferences.drawing.shadowRadius = 2
        preferences.drawing.shadowOpacity = 0.75
        preferences.drawing.shadowColor = UIColor.black
        preferences.drawing.backgroundColor = UIColor.gray
        return preferences
    }()
}

final private class EasyTipViewDelegateImpl: EasyTipViewDelegate {
    
    fileprivate static let delegate = EasyTipViewDelegateImpl()
    
    public func easyTipViewDidTap(_ tipView: EasyTipView) {}
    
    public func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        UIView.tipView = nil
    }
}

extension UIView {
    private static var topView: UIView? {
        return UIApplication.shared.keyWindow?.rootViewController?.view
    }
    
    static var tipView: EasyTipView? {
        didSet {
            topView?.gestureRecognizers?.removeAll(where: { $0.name == "tapScreenForTipView" })
        }
    }
    
    func showTipView(_ text: String) {
        guard AppStorage.infoMessage else { return }
        guard UIView.tipView == nil else { return }
        UIView.tipView = EasyTipView(text: text, preferences: EasyTipView.appPreferences, delegate: EasyTipViewDelegateImpl.delegate)
        UIView.tipView?.show(forView: self)
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(tapScreenAction))
        tapScreen.name = "tapScreenForTipView"
        UIView.topView?.addGestureRecognizer(tapScreen)
    }
    
    @objc private func tapScreenAction(_ selector: UIView) {
        UIView.tipView?.dismiss()
        UIView.tipView = nil
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
