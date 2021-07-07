//
//  LogoutViewLauncher.swift
//  Paw_nder
//
//  Created by William Yeung on 5/21/21.
//

import UIKit

protocol LogoutViewLauncherDelegate: AnyObject {
    func didTapLogout()
}

class LogoutViewLauncher: UIView {
    // MARK: - Properties
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    weak var delegate: LogoutViewLauncherDelegate?
    
    // MARK: - Views
    private let blackBgView = PawView(bgColor: .black.withAlphaComponent(0.5))
    private let logoutView = PawView(bgColor: .white, cornerRadius: 30)
    
    private let headingLabel = PawLabel(text: "Are you sure?", textColor: .black, font: markerFont(20), alignment: .center)
    private let logOutButton = PawButton(title: "Log out", font: markerFont(18))
    private let cancelButton = PawButton(title: "Cancel", font: markerFont(18))
    private lazy var logoutStack = PawStackView(views: [headingLabel, logOutButton, cancelButton], spacing: 15, axis: .vertical, distribution: .fillEqually, alignment: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupActionsAndGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helper
    private func configureUI() {
        blackBgView.alpha = 0
        logoutView.alpha = 0
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.backgroundColor = Colors.lightRed
        logOutButton.layer.cornerRadius = 50/2
    }
    
    private func layoutLogoutCard() {
        logoutView.addSubview(logoutStack)
        logoutStack.setDimension(width: logoutView.widthAnchor, wMult: 0.85)
        logoutStack.center(x: logoutView.centerXAnchor, y: logoutView.centerYAnchor)
        logOutButton.setDimension(hConst: 50)
    }
    
    private func setupActionsAndGestures() {
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissLogoutView)))
        logOutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissLogoutView), for: .touchUpInside)
    }
    
    func showLogoutView() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keyWindow.addSubviews(blackBgView, logoutView)
            blackBgView.frame = keyWindow.frame
            
            let logoutViewWidth = screenWidth * 0.8
            let logoutViewHeight = screenWidth * 0.5
            let centerXPosition = screenWidth/2 - logoutViewWidth/2
            let centerYPosition = screenHeight/2 - logoutViewHeight/2
            logoutView.frame = .init(x: centerXPosition, y: centerYPosition, width: logoutViewWidth, height: logoutViewHeight)
            logoutView.frame.origin.y = centerYPosition + 100
            
            layoutLogoutCard()

            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.blackBgView.alpha = 1
                self?.logoutView.alpha = 1
                self?.logoutView.frame.origin.y = centerYPosition
            }
        }
    }
    
    // MARK: - Selector
    @objc func dismissLogoutView() {
        let logoutViewHeight = screenWidth * 0.6
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
    
    @objc func logout() {
        dismissLogoutView()
        delegate?.didTapLogout()
    }
}
