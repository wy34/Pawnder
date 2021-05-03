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
//    let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
    
    // MARK: - Views
    private let blackBgView = PawView(bgColor: .black.withAlphaComponent(0.5))
    
    private let filterCardView = PawView(bgColor: .blue, cornerRadius: 30)
    private let dismissButton = PawButton(image: xmark, tintColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private let filterTitle = PawLabel(text: "Filters", font: .systemFont(ofSize: 22, weight: .bold), alignment: .center)
    private let saveButton = PawButton(image: checkmark, tintColor: .black, font: .systemFont(ofSize: 16, weight: .bold))
    private lazy var headingStack = PawStackView(views: [dismissButton, filterTitle, saveButton], distribution: .fillEqually, alignment: .fill)
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
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
    func configureUI() {
        dismissButton.contentHorizontalAlignment = .left
        saveButton.contentHorizontalAlignment = .right
        blackBgView.alpha = 0
    }
    
    func layoutFilterCard() {
        filterCardView.addSubviews(headingStack, tableView)
        headingStack.setDimension(width: filterCardView.widthAnchor, height: filterCardView.heightAnchor, wMult: 0.85, hMult: 0.15)
        headingStack.center(to: filterCardView, by: .centerX)
        headingStack.anchor(top: filterCardView.topAnchor, paddingTop: 30)
        tableView.anchor(top: headingStack.bottomAnchor, trailing: headingStack.trailingAnchor, bottom: filterCardView.bottomAnchor, leading: headingStack.leadingAnchor, paddingTop: 30, paddingBottom: 30)
    }
    
    func showFilterView() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            keyWindow.addSubview(self.blackBgView)
            self.blackBgView.frame = keyWindow.frame
            
            keyWindow.addSubview(filterCardView)
            let height = keyWindow.frame.height * 0.45
            filterCardView.frame = .init(x: 0, y: -height, width: keyWindow.frame.width, height: height)
            
            layoutFilterCard()
            
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.blackBgView.alpha = 1
                self.filterCardView.frame.origin.y = 0
            }
        }
    }
    
    func setupActionsAndGestures() {
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFilterView)))
        dismissButton.addTarget(self, action: #selector(dismissFilterView), for: .touchUpInside)
    }
    
    // MARK: - Selector
    @objc func dismissFilterView() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.blackBgView.alpha = 0
            if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
                self.filterCardView.frame.origin.y = -keyWindow.frame.height / 2
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterViewLauncher: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}









struct Filter: UIViewRepresentable {
    func makeUIView(context: Context) -> FilterViewLauncher {
        let filter = FilterViewLauncher()
        return filter
    }
    
    func updateUIView(_ uiView: FilterViewLauncher, context: Context) {
        
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        return Filter()
            .edgesIgnoringSafeArea(.all)
    }
}
