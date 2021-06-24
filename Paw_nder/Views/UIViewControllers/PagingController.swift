//
//  SwipeController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/30/21.
//

import UIKit

class PagingController: UIPageViewController {
    // MARK: - Properties
    var aboutVM: AboutViewModel?
    
    // MARK: - Views
    private var controllers = [PhotoController]()
    private let pagingControlStack = PawStackView(views: [], spacing: 5, distribution: .fillEqually, alignment: .fill)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        layoutUI()
    }

    // MARK: - Helpers
    func layoutUI() {
        view.addSubview(pagingControlStack)
        pagingControlStack.center(to: view, by: .centerX)
        pagingControlStack.setDimension(width: view.widthAnchor, wMult: 0.5)
        pagingControlStack.setDimension(hConst: 5)
        pagingControlStack.anchor(bottom: view.bottomAnchor, paddingBottom: 25)
        view.bringSubviewToFront(pagingControlStack)
    }
    
    func setupImages(aboutVM: AboutViewModel) {
        self.aboutVM = aboutVM
        controllers = aboutVM.imageUrls.map({ PhotoController(imageUrlString: $0) })
        setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
        setupPagingControl()
    }
    
    func setupPagingControl() {
        if aboutVM?.imageUrls.count == 1 { return }
        
        aboutVM?.imageUrls.forEach({ _ in
            let pagingIndicator = PawView(bgColor: Colors.mediumTransparentGray)
            pagingIndicator.layer.cornerRadius = 5/2
            pagingControlStack.addArrangedSubview(pagingIndicator)
        })
        pagingControlStack.subviews[0].backgroundColor = .white
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension PagingController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: { $0 == currentPhotoController }) {
            pagingControlStack.arrangedSubviews.forEach({ $0.backgroundColor = Colors.mediumTransparentGray })
            pagingControlStack.arrangedSubviews[index].backgroundColor = .white
        }
    }
}

// MARK: - PhotoController
class PhotoController: UIViewController {
    // MARK: - Views
    let imageView = PawImageView(image: nil, contentMode: .scaleAspectFill)
    
    // MARK: - Init
    init(imageUrlString: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.setImage(imageUrlString: imageUrlString, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fill(superView: view)
    }
}
