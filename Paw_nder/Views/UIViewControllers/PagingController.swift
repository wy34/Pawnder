//
//  SwipeController.swift
//  Paw_nder
//
//  Created by William Yeung on 4/30/21.
//

import UIKit

class PagingController: UIPageViewController {
    // MARK: - Properties
    
    // MARK: - Views
    var controllers = [PhotoController]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
    }

    // MARK: - Helpers
    func setupImages(aboutVM: AboutViewModel) {
        controllers = aboutVM.imageUrls.map({ PhotoController(imageUrlString: $0) })
        setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
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
}




class PhotoController: UIViewController {
    // MARK: - Views
    let imageView = PawImageView(image: UIImage(named: bob3)!, contentMode: .scaleAspectFill)
    
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
