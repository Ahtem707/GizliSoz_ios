//
//  LevelsViewController.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.01.2023.
//

import UIKit

final class LevelsViewController: BaseViewController {
    
    // MARK: - Public variables
    var viewModel: LevelsViewModelProtocol!
    var layouts: LevelsBuilder.Layouts!
    var appearance: LevelsBuilder.Appearances!
    
    // MARK: - Private variables
    private let backImage = UIImageView()
    private let collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 15
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionLayout)
        return collection
    }()
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupLayouts()
        setupAppearance()
        setupContent()
    }
}

// MARK: - Setup private functions
extension LevelsViewController {
    private func setupSubviews() {
        backImage.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backImage)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(LevelsCollectionCell.self, forCellWithReuseIdentifier: LevelsCollectionCell.identifier)
    }
    
    private func setupLayouts() {
        backImage.pinToSuperview()
        collectionView.pinToSuperview(edges: .all, insets: layouts.collectionViewEdges, safeArea: true)
    }
    
    private func setupAppearance() {
        backImage.image = appearance.backImage
        collectionView.backgroundColor = .clear
    }
    
    private func setupContent() {
        title = viewModel.getViewTitle()
        titleTranslate = viewModel.getViewTitle().translate
    }
}

// MARK: - LevelsViewControllerProtocol
extension LevelsViewController: LevelsViewControllerDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension LevelsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCollectionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = viewModel.getCollectionItem(indexPath)
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LevelsCollectionCell.identifier,
            for: indexPath
        ) as! LevelsCollectionCell
        cell.text = String(cellData.level)
        cell.type = cellData.type
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LevelsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = viewModel.getCollectionItem(indexPath)
        guard AppStorage.setLevel(cellData.level) else { return }
        collectionView.reloadData()
    }
}
