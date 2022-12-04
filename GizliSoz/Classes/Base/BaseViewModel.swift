//
//  BaseViewModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import Foundation

typealias BaseViewModel = ViewModelProtocol & ViewModelImplement

protocol ViewModelProtocol: AnyObject {
    associatedtype Delegate = NSObjectProtocol
    var delegate: Delegate? { get set }
    
    func initialize()
}

class ViewModelImplement {
    
    init() {
        
    }
}
