//
//  ActionSheetViewController.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 06.01.2023.
//

import UIKit

extension ActionSheetViewController {
    struct Layouts {
        let containerViewRadius: CGFloat = 16
        let indicatorRadius: CGFloat = 8
        let indicatorEdge = UIEdgeInsets(all: 8)
        let indicatorSize = CGSize(width: 100, height: 5)
        let tableViewEdges = UIEdgeInsets(all: 10)
        let tableViewCellHeight: CGFloat = 50
    }
    
    struct Appearance {
        let viewBackground = UIColor.init(white: 255, alpha: 0)
        let contentViewBackground = UIColor(0xFFFFFF)
        let indicatorBackground = UIColor(0xC8CCDB)
        let animatiionDuration = 0.25
    }
}

class ActionSheetViewController: UIViewController {
    
    var dataSource: [ActionSheetModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Private variable
    private let layouts = Layouts()
    private let appearance = Appearance()
    
    private let contentView = UIView()
    private let indicatorView = UIView()
    private let tableView = UITableView()
    
    private var contentViewHeight: NSLayoutConstraint?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubview()
        setupLayouts()
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cellCount = dataSource.count
        let tableHeight = layouts.tableViewCellHeight * CGFloat(cellCount)
        let height = layouts.indicatorEdge.top + layouts.indicatorSize.height + layouts.tableViewEdges.top + tableHeight + layouts.tableViewEdges.bottom
        updateContentHeight(height)
    }
}

extension ActionSheetViewController {
    private func setupSubview() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        contentView.addSubview(indicatorView)
        contentView.addSubview(tableView)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewTapAction))
        view.addGestureRecognizer(viewTap)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: 0).activate()
        
        contentView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: layouts.containerViewRadius)
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layouts.indicatorEdge.top),
            indicatorView.widthAnchor.constraint(equalToConstant: layouts.indicatorSize.width),
            indicatorView.heightAnchor.constraint(equalToConstant: layouts.indicatorSize.height),
            indicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        indicatorView.layer.cornerRadius = layouts.indicatorRadius
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: layouts.tableViewEdges.top),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -layouts.tableViewEdges.bottom),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: layouts.tableViewEdges.left),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -layouts.tableViewEdges.right)
        ])
        tableView.rowHeight = layouts.tableViewCellHeight
    }
    
    private func setupAppearance() {
        view.backgroundColor = appearance.viewBackground
        contentView.backgroundColor = appearance.contentViewBackground
        indicatorView.backgroundColor = appearance.indicatorBackground
    }
    
    private func updateContentHeight(_ value: CGFloat?) {
        UIView.animate(withDuration: appearance.animatiionDuration) { [weak self] in
            guard let self = self else { return }
            guard let value = value else {
                self.contentViewHeight?.constant = 0
                self.dismiss(animated: false)
                return
            }
            if self.view.bounds.height > value {
                self.contentViewHeight?.constant = value
            } else {
                self.contentViewHeight?.constant = self.view.bounds.height
            }
            self.view.updateConstraints()
        }
    }
    
    @objc private func viewTapAction(_ sender: UIView) {
        updateContentHeight(nil)
    }
}

// MARK: - UITableViewDataSource
extension ActionSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActionSheetCell
        cell.title = dataSource[indexPath.row].title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ActionSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource[indexPath.row].action()
    }
}
