//
//  WordsListProtocol.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 30.03.2023.
//

import Foundation

protocol WordsListViewModelProtocol {
    
    func getSectionCount() -> Int
    
    func getSection(_ section: Int) -> WordHeaderData
    
    func getCellCount(_ section: Int) -> Int
    
    func getCellData(_ indexPath: IndexPath) -> WordCellData
}

protocol WordsListViewControllerDelegate {
    
}
