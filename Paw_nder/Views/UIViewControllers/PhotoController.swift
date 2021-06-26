//
//  PhotoController.swift
//  Paw_nder
//
//  Created by William Yeung on 6/25/21.
//

import UIKit

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
