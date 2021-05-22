//
//  LogoutViewLauncher.swift
//  Paw_nder
//
//  Created by William Yeung on 5/21/21.
//

import UIKit

class LogoutViewLauncher: NSObject {
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // MARK: - Views
    private let blackBgView = PawView(bgColor: .black.withAlphaComponent(0.5))
    private let logoutView = PawView(bgColor: .white, cornerRadius: 30)
    
    // MARK: - Init
    override init() {
        super.init()
        configureUI()
        layoutUI()
        setupActionsAndGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helper
    private func configureUI() {
        blackBgView.alpha = 0
        logoutView.alpha = 0
    }
    
    private func layoutUI() {
        
    }
    
    private func setupActionsAndGestures() {
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissLogoutView)))
    }
    
    
    func showLogoutView() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keyWindow.addSubviews(blackBgView, logoutView)
            blackBgView.frame = keyWindow.frame
            
            let logoutViewWidth = screenWidth * 0.85
            let logoutViewHeight = screenWidth * 0.6
            let centerXPosition = screenWidth/2 - logoutViewWidth/2
            let centerYPosition = screenHeight/2 - logoutViewHeight/2
            logoutView.frame = .init(x: centerXPosition, y: centerYPosition, width: logoutViewWidth, height: logoutViewHeight)
            logoutView.frame.origin.y = centerYPosition + 100

            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.blackBgView.alpha = 1
                self?.logoutView.alpha = 1
                self?.logoutView.frame.origin.y = centerYPosition
            }
        }
    }
    
    // MARK: - Selector
    @objc func dismissLogoutView() {
        let logoutViewWidth = screenWidth * 0.85
        let logoutViewHeight = screenWidth * 0.6
        let centerXPosition = screenWidth/2 - logoutViewWidth/2
        let centerYPosition = screenHeight/2 - logoutViewHeight/2
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.blackBgView.alpha = 0
            self.logoutView.alpha = 0
            self.logoutView.frame.origin.y = centerYPosition + 100
        } completion: { [weak self] _ in
            self?.blackBgView.removeFromSuperview()
            self?.logoutView.removeFromSuperview()
        }
    }
}
