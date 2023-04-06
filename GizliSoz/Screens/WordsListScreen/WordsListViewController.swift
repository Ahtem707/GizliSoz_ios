//
//  WordsListViewController.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 30.03.2023.
//

import UIKit

final class WordsListViewController: BaseViewController {
    
    // MARK: - Public variables
    var viewModel: WordsListViewModelProtocol!
    var layouts: WordsListBuilder.Layouts!
    var appearance: WordsListBuilder.Appearances!
    
    // MARK: - Private variables
    private let tableView = UITableView()
    
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

// MARK: - Setup functions
extension WordsListViewController {
    private func setupSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.preservesSuperviewLayoutMargins = false
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.allowsSelection = false
        tableView.registerCellClass(WordCell.self)
    }
    
    private func setupLayouts() {
        tableView.pinToSuperview(insets: layouts.tableViewEdges)
    }
    
    private func setupAppearance() {
        view.backgroundColor = UIColor.white
    }
    
    private func setupContents() {
        
    }
    
    private func setupAction() {
        
    }
}

// MARK: - WordsListViewControllerDelegate
extension WordsListViewController: WordsListViewControllerDelegate {
    
}

extension WordsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = WordHeader()
        header.data = viewModel.getSection(section)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WordCell()
        cell.data = viewModel.getCellData(indexPath)
        return cell
    }
}
