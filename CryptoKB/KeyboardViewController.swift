//
//  KeyboardViewController.swift
//  CryptoKB
//
//  Created by Pi on 09/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import ReactiveSwift

//weak var GlobalKeyboardViewController: KeyboardViewController! = nil
var GloabalKeyboardShiftState: ShiftState = .disabled

final class KeyboardViewController: UIInputViewController {
    
    // MARK: -
    // MARK: Class or Static Properties
    static let shiftStateChangedNotification = Notification.Name("ShiftStateChanged")
    
    // MARK: -
    // MARK: Instance Properties
    
    var cipherName: String = "Caesar" {didSet{topBar.cipherName = cipherName}}
    var cipherType: CipherType = .caesar {didSet{textInterpreter.cipherType = cipherType}}
    var cipherKey: String = "03" {didSet{textInterpreter.cipherKey = cipherKey}}
    
    lazy var keyboardView: KeyboardView = {

        return KeyboardView(withDelegate:self);
    
    
    }()
    
    lazy var topBar: TopBarView = {
        let tbv = TopBarView(delegate:self)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.cipherName = self.cipherName
        return tbv
    }()
    
    var heuristicTextLabel: UILabel { return topBar.leftLabel}
    var encryptedTextLabel: UILabel { return topBar.rightLabel}
    
    
    var heightConstraint: NSLayoutConstraint!
    lazy var inputViewHeight: CGFloat = self.topBarHeight + self.keyboardViewheight
    var topBarHeight: CGFloat = LayoutConstraints.topBarHeight
    var keyboardViewheight: CGFloat = LayoutConstraints.keyboardViewHeight
    lazy var dummyLabel: UILabel = {let b = UILabel(); b.translatesAutoresizingMaskIntoConstraints = false; return b}()
    var keyboradViewLayoutConstraints: [NSLayoutConstraint] = []
    
    var shiftState: ShiftState = .disabled {
        didSet {
            
            GloabalKeyboardShiftState = shiftState
            if (oldValue != shiftState) {
                NotificationCenter.default.post(name: KeyboardViewController.shiftStateChangedNotification, object: nil)
            }
        }
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
        loadCipherSetting()
        view.addSubview(topBar)
        view.addSubview(keyboardView)
        
        keyboardView.reactive.continuousKeyPressed.observeValues { (keyboardViewItem) in
            let key = keyboardViewItem.key
            print(key)
        }
        
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
    
    
    // MARK: -
    // MARK: Cipher Setting
    private func loadCipherSetting() {
        if let cipherTypeRawValue = UserDefaults.standard.value(forKey: KeyboardExtensionConstants.cipherType) as? Int,
           let cipherType = CipherType(rawValue: cipherTypeRawValue) {
            self.cipherType = cipherType
        } else {
            UserDefaults.standard.setValue(self.cipherType.rawValue, forKey: KeyboardExtensionConstants.cipherType)
        }
        
        if let cipherName = UserDefaults.standard.value(forKey: KeyboardExtensionConstants.cipherName) as? String {
            self.cipherName = cipherName
        } else {
            UserDefaults.standard.setValue(self.cipherName, forKey: KeyboardExtensionConstants.cipherName)
        }
        
        if let cipherKey = UserDefaults.standard.value(forKey: KeyboardExtensionConstants.cipherKey) as? String{
            self.cipherKey = cipherKey
        } else {
            UserDefaults.standard.setValue(self.cipherKey, forKey: KeyboardExtensionConstants.cipherKey)
        }
        UserDefaults.standard.synchronize()
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
    
    let checkedWord = SpellChecker.defaultChecker.correct(word: "Helol")
    print(checkedWord)
}














