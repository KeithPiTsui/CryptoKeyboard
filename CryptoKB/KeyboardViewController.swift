//
//  KeyboardViewController.swift
//  CryptoKB
//
//  Created by Pi on 09/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    lazy var keyboardView: KeyboardView = KeyboardView()
    var heightConstraint: NSLayoutConstraint!
    lazy var inputViewHeight: CGFloat = UIScreen.main.bounds.height / 2
    
    
    override func updateViewConstraints() {
        guard view.frame.width != 0 && view.frame.height != 0 else {return }
        setUpHeightConstraint()
        super.updateViewConstraints()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()

        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(b)
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: Set up height constraint
    func setUpHeightConstraint() {
        guard heightConstraint == nil else { heightConstraint.constant = inputViewHeight; return }
        heightConstraint = NSLayoutConstraint(item: view,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: inputViewHeight)
        heightConstraint.priority = UILayoutPriority(UILayoutPriorityDefaultHigh)
        view.addConstraint(heightConstraint)
    }
}
















