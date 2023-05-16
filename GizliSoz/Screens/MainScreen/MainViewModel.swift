//
//  MainViewModel.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import Foundation

final class MainViewModel: BaseViewModel {
    
    var delegate: MainViewControllerDelegate?
    
    func initialize() {
        
    }
    
    func viewDidAppear() {
        AppStorage.share.fetchAppInit()
    }
}

// MARK: - MainViewModelProtocol
extension MainViewModel: MainViewModelProtocol {
    
}
