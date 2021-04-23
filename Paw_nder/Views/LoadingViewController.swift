//
//  LoadingVC.swift
//  Paw_nder
//
//  Created by William Yeung on 4/22/21.
//

import UIKit
import SwiftUI

class LoadingViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Views
    private let backgroundView = PawView(bgColor: darkTransparentGray)
    
    private let loadingView = PawView(bgColor: lightTransparentGray, cornerRadius: 15)
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let loadingLabel = PawLabel(text: "Loading...", textColor: .white, font: .systemFont(ofSize: 14, weight: .medium), alignment: .center)
    private lazy var loadingStack = PawStackView(views: [spinner, loadingLabel], spacing: 5, axis: .vertical)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    fileprivate func layoutUI() {
        view.addSubview(backgroundView)
        backgroundView.fill(superView: view)
        
        backgroundView.addSubview(loadingView)
        loadingView.makePerfectSquare(anchor: backgroundView.widthAnchor, multiplier: 0.25)
        loadingView.center(to: backgroundView, by: .centerX)
//        loadingView.center(to: backgroundView, by: .centerY, withMultiplierOf: 0.75)
        loadingView.center(x: backgroundView.centerXAnchor, y: backgroundView.centerYAnchor)
        
        loadingView.addSubview(loadingStack)
        loadingStack.center(x: loadingView.centerXAnchor, y: loadingView.centerYAnchor)
    }
    
    func showLoader() {
        layoutUI()
    }
    
    func dismissLoader() {
        backgroundView.removeFromSuperview()
        loadingView.removeFromSuperview()
        loadingStack.removeFromSuperview()
    }
}




struct Loading: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoadingViewController {
        let loadingVC = LoadingViewController()
        return loadingVC
    }
    
    func updateUIViewController(_ uiViewController: LoadingViewController, context: Context) {
        
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
