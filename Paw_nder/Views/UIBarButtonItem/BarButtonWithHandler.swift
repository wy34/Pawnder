//
//  BarButtonWithHanlder.swift
//  Paw_nder
//
//  Created by William Yeung on 5/31/21.
//

import UIKit

class BarButtonWithHandler: UIBarButtonItem {
    // MARK: - Properties
    typealias ActionHandler = (UIBarButtonItem) -> Void

    private var actionHandler: ActionHandler?

    // MARK: - Init
    convenience init(image: UIImage?, style: UIBarButtonItem.Style, actionHandler: ActionHandler?) {
        self.init(image: image, style: style, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }

    convenience init(title: String?, style: UIBarButtonItem.Style, actionHandler: ActionHandler?) {
        self.init(title: title, style: style, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }

    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, actionHandler: ActionHandler?) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: #selector(barButtonItemPressed(sender:)))
        target = self
        self.actionHandler = actionHandler
    }

    // MARK: - Selector
    @objc func barButtonItemPressed(sender: UIBarButtonItem) {
        actionHandler?(sender)
    }
}

