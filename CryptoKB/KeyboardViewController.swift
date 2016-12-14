//
//  KeyboardViewController.swift
//  CryptoKB
//
//  Created by Pi on 09/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

weak var GlobalKeyboardViewController: KeyboardViewController! = nil

final class KeyboardViewController: UIInputViewController {
    
    // MARK: -
    // MARK: Class or Static Properties
    static let shiftStateChangedNotification = Notification.Name("ShiftStateChanged")
    
    // MARK: -
    // MARK: Instance Properties
    lazy var keyboardView: KeyboardView = { return KeyboardView(withDelegate:self); }()
    
    lazy var topBar: TopBarView = {
        let tbv = TopBarView(delegate:self)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        return tbv
    }()
    
    var heuristicTextLabel: UILabel { return topBar.leftLabel}
    var encryptedTextLabel: UILabel { return topBar.rightLabel}
    //var decryptedTextLabel: UILabel { return topBar.rightLabel}
    
    
    var heightConstraint: NSLayoutConstraint!
    lazy var inputViewHeight: CGFloat = self.topBarHeight + self.keyboardViewheight
    var topBarHeight: CGFloat = LayoutConstraints.topBarHeight
    var keyboardViewheight: CGFloat = LayoutConstraints.keyboardViewHeight
    lazy var dummyLabel: UILabel = {let b = UILabel(); b.translatesAutoresizingMaskIntoConstraints = false; return b}()
    var keyboradViewLayoutConstraints: [NSLayoutConstraint] = []
    
    var shiftState: ShiftState = .disabled {
        didSet { if (oldValue != shiftState) {NotificationCenter.default.post(name: KeyboardViewController.shiftStateChangedNotification, object: nil)}}
    }
    
    var autoPeriodState: AutoPeriodState = .noSpace
    
    lazy var textInterpreter: InputInterpreter = { return InputInterpreter(delegate: self)}()
    
    
    let backspaceDelay: TimeInterval = 0.5
    let backspaceRepeat: TimeInterval = 0.07
    var backspaceDelayTimer: Timer?
    var backspaceRepeatTimer: Timer?
    
    
    
    // MARK: -
    // MARK: Layout Keyboard
    
    override func updateViewConstraints() {
        guard view.frame.width != 0 && view.frame.height != 0 else {return }
        setUpHeightConstraint()
        setupKeyboardLayoutConstraints()
        super.updateViewConstraints()
    }
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
        
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: topBar,
                                                                 attribute: .height,
                                                                 relatedBy: .equal,
                                                                 toItem: nil,
                                                                 attribute: .notAnAttribute,
                                                                 multiplier: 1,
                                                                 constant: topBarHeight))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: topBar,
                                                                 attribute: .width,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .width,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: topBar,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .top,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: topBar,
                                                                 attribute: .left,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .left,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: keyboardView,
                                                               attribute: .height,
                                                               relatedBy: .equal,
                                                               toItem: nil,
                                                               attribute: .notAnAttribute,
                                                               multiplier: 1,
                                                               constant: keyboardViewheight))
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
                                                                 toItem: topBar,
                                                                 attribute: .bottom,
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
    
    // MARK: -
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        GlobalKeyboardViewController = self
        view.addSubview(topBar)
        view.addSubview(keyboardView)
//        printFontNames()
        //testSpellingAutoCorrector()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: -
    // MARK: Text Editing
    override func textDidChange(_ textInput: UITextInput?) {
        setCapsIfNeeded()
    }
}

func printFontNames() {
    for familyName in UIFont.familyNames {
        for fontname in UIFont.fontNames(forFamilyName: familyName) {
            print("Family:\(familyName)\nFont:\(fontname)")
        }
    }
}

func testSpellingAutoCorrector() {
    let checker = SpellChecker(contentsOfFile: "words.txt")
    _ = checker?.correct(word: "hello")
    //print(checkedWord)
}














