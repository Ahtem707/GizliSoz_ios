//
//  SettingsViewController.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import UIKit

final class SettingsViewController: BaseViewController {
    
    // MARK: - Public variables
    var viewModel: SettingsViewModelProtocol!
    var layouts: SettingsBuilder.Layouts!
    var appearance: SettingsBuilder.Appearances!
    
    // MARK: - Private variables
    private let backImage = UIImageView()
    private let tableView = UITableView()
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupLayouts()
        setupAppearance()
    }
}

// MARK: - Setup functions
extension SettingsViewController {
    private func setupSubviews() {
        backImage.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backImage)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        tableView.registerCellClass(SettingsSwitchCell.self)
        tableView.registerCellClass(SettingsMoreCell.self)
    }
    
    private func setupLayouts() {
        backImage.pinToSuperview()
        tableView.pinToSuperview(edges: .all, insets: layouts.tableViewEdges)
    }
    
    private func setupAppearance() {
        backImage.image = appearance.backImage
        tableView.backgroundColor = .clear
    }
}

// MARK: - SettingsViewControllerDelegate
extension SettingsViewController: SettingsViewControllerDelegate {
    
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTableCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = viewModel.getTableItem(indexPath)
        if let cellData = cellData as? SettingsSwitchCellModel {
            let cell: SettingsSwitchCell = tableView.dequeue(cellForRowAt: indexPath)
            cell.title = cellData.title
            cell.isEnable = cellData.isEnable
            cell.action = cellData.action
            return cell
        } else if let cellData = cellData as? SettingsMoreCellModel {
            let cell: SettingsMoreCell = tableView.dequeue(cellForRowAt: indexPath)
            cell.title = cellData.title
            cell.action = cellData.action
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
