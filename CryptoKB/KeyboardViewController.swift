//
//  KeyboardViewController.swift
//  CryptoKB
//
//  Created by Pi on 09/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    lazy var keyboardView: KeyboardView = {
        return KeyboardView(withDelegate:self);
    }()
    var heightConstraint: NSLayoutConstraint!
    lazy var inputViewHeight: CGFloat = 216
    lazy var dummyLabel: UILabel = {let b = UILabel(); b.translatesAutoresizingMaskIntoConstraints = false; return b}()
    
    
    override func updateViewConstraints() {
        guard view.frame.width != 0 && view.frame.height != 0 else {return }
        setUpHeightConstraint()
        super.updateViewConstraints()
    }
    
    // MARK: Set up height constraint
    private func setUpHeightConstraint() {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(view.frame)
        keyboardView.layoutKeyboard()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(dummyLabel)
        view.addSubview(keyboardView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setNeedsUpdateConstraints()
    }
}

extension KeyboardViewController: KeyboardViewDelegate {

    func changeKeyboard(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressBackspace(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressBackspaceCancel(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressShiftDown(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressShiftUpInside(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func doubleTapShift(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func nextKeyboardPage(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressSettings(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressAnOutputItem(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func highlightItem(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func unhighlightItem(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func playClickSound(_ sender: KeyboardViewItem){
        print("\(#function):\(#line)")
    }
}















