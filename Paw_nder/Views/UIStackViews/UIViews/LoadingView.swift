//
//  LoadingView.swift
//  Paw_nder
//
//  Created by William Yeung on 4/23/21.
//

import UIKit

class LoadingView: UIView {
    // MARK: - Views
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = #colorLiteral(red: 0.3220641613, green: 0.3205376863, blue: 0.3232477307, alpha: 1)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    fileprivate func layoutUI() {
        addSubview(spinner)
        spinner.center(x: centerXAnchor, y: centerYAnchor)
    }
    
    func showLoader() {
        layoutUI()
    }
    
    func dismissLoader() {
        spinner.removeFromSuperview()
    }
}
