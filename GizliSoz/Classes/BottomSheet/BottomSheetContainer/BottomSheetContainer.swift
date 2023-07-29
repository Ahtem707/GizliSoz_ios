//
//  BottomSheetContainer.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.07.2023.
//

import UIKit

protocol BottomSheetContainerProtocol {
    var contentHeight: CGFloat { get }
}

extension BottomSheetContainerViewController {
    struct Layouts {
        let containerViewRadius: CGFloat = 16
        let indicatorRadius: CGFloat = 2
        let indicatorEdge = UIEdgeInsets(all: 8)
        let indicatorSize = CGSize(width: 100, height: 5)
        let contentViewEdges = UIEdgeInsets(top: 10, leading: 10, bottom: 30, trailing: 10)
    }
    
    struct Appearance {
        let viewBackground = UIColor.init(white: 255, alpha: 0)
        let contentViewBackground = UIColor(0xFFFFFF)
        let indicatorBackground = UIColor(0xC8CCDB)
        let animationDuration: CGFloat = 0.25
    }
}

class BottomSheetContainerViewController: UIViewController {
    
    // MARK: - Private variable
    private let layouts = Layouts()
    private let appearance = Appearance()
    
    private let frameView = UIView()
    private let indicatorView = UIView()
    private let contentView = UIView()
    
    private var contentViewHeight: NSLayoutConstraint?
    private var frameViewBottom: NSLayoutConstraint?
    
    // MARK: View Lifecycle
    
    convenience init(_ viewController: UIViewController) {
        self.init()
        
        modalPresentationStyle = .overFullScreen
        contentView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            viewController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        if var viewController = (viewController as? BottomSheetContainerProtocol) {
            updateContentHeight(viewController.contentHeight)
        } else {
            let height = UIScreen.main.bounds.height - 100
            updateContentHeight(height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubview()
        setupLayouts()
        setupAppearance()
    }
}

extension BottomSheetContainerViewController {
    private func setupSubview() {
        frameView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(frameView)
        frameView.addSubview(indicatorView)
        frameView.addSubview(contentView)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewTapAction))
        viewTap.delegate = self
        view.addGestureRecognizer(viewTap)

        let viewSwipe = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipeAction))
        viewSwipe.direction = .down
        view.addGestureRecognizer(viewSwipe)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            frameView.leftAnchor.constraint(equalTo: view.leftAnchor),
            frameView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        frameView.setRoundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: layouts.containerViewRadius)
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: frameView.topAnchor, constant: layouts.indicatorEdge.top),
            indicatorView.widthAnchor.constraint(equalToConstant: layouts.indicatorSize.width),
            indicatorView.heightAnchor.constraint(equalToConstant: layouts.indicatorSize.height),
            indicatorView.centerXAnchor.constraint(equalTo: frameView.centerXAnchor)
        ])
        indicatorView.layer.cornerRadius = layouts.indicatorRadius
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: layouts.contentViewEdges.top),
            contentView.leftAnchor.constraint(equalTo: frameView.leftAnchor, constant: layouts.contentViewEdges.left),
            contentView.rightAnchor.constraint(equalTo: frameView.rightAnchor, constant: -layouts.contentViewEdges.right),
            contentView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -layouts.contentViewEdges.bottom)
        ])
        
        let screenHeight = UIScreen.main.bounds.height
        contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: screenHeight).activate()
        frameViewBottom = frameView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
    }
    
    private func setupAppearance() {
        view.backgroundColor = appearance.viewBackground
        frameView.backgroundColor = appearance.contentViewBackground
        indicatorView.backgroundColor = appearance.indicatorBackground
        contentView.backgroundColor = appearance.contentViewBackground
    }
    
    private func updateContentHeight(_ value: CGFloat?) {
        if let value = value {
            if view.bounds.height > value {
                contentViewHeight?.constant = value
                frameViewBottom?.constant = value
            } else {
                contentViewHeight?.constant = view.bounds.height
                frameViewBottom?.constant = view.bounds.height
            }
            view.layoutIfNeeded()
            
            frameViewBottom?.constant = .zero
            UIView.animate(withDuration: appearance.animationDuration, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        } else {
            frameViewBottom?.constant = contentViewHeight?.constant ?? .zero
            UIView.animate(withDuration: appearance.animationDuration, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                self?.dismiss(animated: false)
            })
        }
    }
    
    @objc private func viewTapAction(_ gesture: UIGestureRecognizer) {
        updateContentHeight(nil)
    }
    
    @objc private func viewSwipeAction(_ gesture: UIGestureRecognizer) {
        updateContentHeight(nil)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BottomSheetContainerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if touch.view?.isDescendant(of: contentView) == true {
            return false
         }
         return true
    }
}
