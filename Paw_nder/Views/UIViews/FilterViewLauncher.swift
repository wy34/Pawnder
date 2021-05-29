//
//  FilterVC.swift
//  Paw_nder
//
//  Created by William Yeung on 5/3/21.
//

import UIKit
import SwiftUI


class FilterViewLauncher: UIView {
    // MARK: - Properties
    
    // MARK: - Views
    private let blackBgView = PawView(bgColor: .black.withAlphaComponent(0.5))
    
    private let filterCardView = PawView(bgColor: bgLightGray, cornerRadius: 30)
    
    private let bgFillerView = PawView(bgColor: .white)
    
    let filterVC = FilterVC()
    lazy var filterNavController = UINavigationController(rootViewController: filterVC)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupActionsAndGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        blackBgView.alpha = 0
        bgFillerView.layer.cornerRadius = 30
        bgFillerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func layoutFilterCard() {
        filterCardView.addSubviews(bgFillerView, filterNavController.view)
        bgFillerView.anchor(top: filterCardView.topAnchor, trailing: filterCardView.trailingAnchor, leading: filterCardView.leadingAnchor)
        bgFillerView.setDimension(hConst: 50)
        
        filterNavController.view.fill(superView: filterCardView, withPadding: .init(top: 12, left: 0, bottom: 0, right: 0))
        filterNavController.view.layer.cornerRadius = 30
    }
    
    func showFilterViewFor(user: User?) {
        filterVC.filterViewLauncher = self
        filterVC.loadDataFor(user: user)
        
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keyWindow.addSubview(self.blackBgView)
            self.blackBgView.frame = keyWindow.frame
            
            keyWindow.addSubview(filterCardView)
            let height = keyWindow.frame.width * 1.75
            filterCardView.frame = .init(x: 0, y: keyWindow.frame.height, width: keyWindow.frame.width, height: height)
            
            layoutFilterCard()
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {[weak self] in
                guard let self = self else { return }
                self.blackBgView.alpha = 1
                self.filterCardView.frame.origin.y = keyWindow.frame.height - height
            }
        }
    }
    
    private func setupActionsAndGestures() {
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFilterView)))
    }
    
    // MARK: - Selector
    @objc func dismissFilterView() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {[weak self] in
            guard let self = self else { return }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            self.blackBgView.alpha = 0
            if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
                self.filterCardView.frame.origin.y = keyWindow.frame.height
            }
        }
    }
}
