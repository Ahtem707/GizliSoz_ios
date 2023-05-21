//
//  BaseViewController.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import UIKit

typealias BaseViewController = ViewControllerProtocol & ViewControllerImplement

protocol ViewControllerProtocol: AnyObject {
    associatedtype ViewModel = NSObjectProtocol
    var viewModel: ViewModel! { get set }
}

class ViewControllerImplement: UIViewController {
    
    private let titleLabel = AppLabel()
    
    override var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.textColor = AppColor.Text.white
            titleLabel.font = AppFont.font(style: .bold, size: 20)
            titleLabel.frame.size.width = 100
            navigationItem.titleView = titleLabel
        }
    }
    
    var titleTranslate: String? {
        didSet {
            titleLabel.tipViewText = titleTranslate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.backButtonTitle = AppText.System.back
    }
}
