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
    var keyboradViewLayoutConstraints: [NSLayoutConstraint] = []
    
    
    override func updateViewConstraints() {
        guard view.frame.width != 0 && view.frame.height != 0 else {return }
        setUpHeightConstraint()
        setupKeyboardLayoutConstraints()
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
    
    private func setupKeyboardLayoutConstraints() {
        guard keyboradViewLayoutConstraints.isEmpty else { return }
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: keyboardView,
                                                               attribute: .height,
                                                               relatedBy: .equal,
                                                               toItem: view,
                                                               attribute: .height,
                                                               multiplier: 1,
                                                               constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: keyboardView,
                                                                 attribute: .width,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .width,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: keyboardView,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .top,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: keyboardView,
                                                                 attribute: .left,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .left,
                                                                 multiplier: 1,
                                                                 constant: 0))
        view.addConstraints(keyboradViewLayoutConstraints)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
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
        advanceToNextInputMode()
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















