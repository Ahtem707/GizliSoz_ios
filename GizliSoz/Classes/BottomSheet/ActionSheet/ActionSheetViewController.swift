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
        let indicatorRadius: CGFloat = 2
        let indicatorEdge = UIEdgeInsets(all: 8)
        let indicatorSize = CGSize(width: 100, height: 5)
        let tableViewEdges = UIEdgeInsets(top: 10, leading: 10, bottom: 30, trailing: 10)
        let tableViewCellHeight: CGFloat = 50
    }
    
    struct Appearance {
        let viewBackground = UIColor.init(white: 255, alpha: 0)
        let contentViewBackground = UIColor(0xFFFFFF)
        let indicatorBackground = UIColor(0xC8CCDB)
        let tableViewBackground = UIColor.init(white: 255, alpha: 0)
        let animationDuration: CGFloat = 0.25
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
    private var contentViewBottom: NSLayoutConstraint?
    
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
        viewTap.delegate = self
        view.addGestureRecognizer(viewTap)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: 0).activate()
        contentViewBottom = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        
        contentView.setRoundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: layouts.containerViewRadius)
        
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
        tableView.backgroundColor = appearance.tableViewBackground
    }
    
    private func updateContentHeight(_ value: CGFloat?) {
        if let value = value {
            if view.bounds.height > value {
                contentViewHeight?.constant = value
                contentViewBottom?.constant = value
            } else {
                contentViewHeight?.constant = view.bounds.height
                contentViewBottom?.constant = view.bounds.height
            }
            view.layoutIfNeeded()
            
            contentViewBottom?.constant = .zero
            UIView.animate(withDuration: appearance.animationDuration, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        } else {
            contentViewBottom?.constant = contentViewHeight?.constant ?? .zero
            UIView.animate(withDuration: appearance.animationDuration, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                self?.dismiss(animated: false)
            })
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
        updateContentHeight(nil)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ActionSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if touch.view?.isDescendant(of: tableView) == true {
            return false
         }
         return true
    }
}
