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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.backButtonTitle = "Artqa"
    }
}
