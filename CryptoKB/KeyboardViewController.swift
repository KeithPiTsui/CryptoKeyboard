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
import Prelude

struct KeyboardExtensionConstants {
    static let cipherType = "CipherType"
    static let cipherKey = "CipherKey"
    static let cipherName = "CipherName"
}


final class KeyboardViewController: UIInputViewController {
    
    let viewModel: KeyboardViewModel =  KeyboardViewModel()
    
    @IBOutlet weak var rightViewLeftTag: UILabel!
    @IBOutlet weak var leftViewLeftTag: UILabel!
    @IBOutlet weak var topBarRightView: UIView!
    @IBOutlet weak var topBarLeftView: UIView!
    @IBOutlet weak var heuristicLabel: UILabel!
    @IBOutlet weak var encryptedLabel: UILabel!
    @IBOutlet weak var cipherLabel: UILabel!
    @IBOutlet weak var keyboardView: KeyboardView!
    @IBOutlet weak var heuristicBtn: UIButton!
    @IBOutlet weak var encryptedBtn: UIButton!
    
    // MARK: -
    // MARK: Instance Properties
    
    var cipherName: String = "Caesar" {didSet{cipherLabel.text = cipherName}}
    var cipherType: CipherType = .caesar {didSet{textInterpreter.cipherType = cipherType}}
    var cipherKey: String = "03" {didSet{textInterpreter.cipherKey = cipherKey}}
    var shiftState: ShiftState = .disabled { didSet { keyboardView.shiftState = shiftState }}
    var autoPeriodState: AutoPeriodState = .noSpace
    lazy var textInterpreter: InputInterpreter = { return InputInterpreter(delegate: self)}()
    
    var leftChars: [String] = [] {didSet{heuristicLabel.text = leftChars.reduce("", +)}}
    var rightChars: [String] = [] {didSet{encryptedLabel.text = rightChars.reduce("", +)}}
    
    let backspaceDelay: TimeInterval = 0.5
    let backspaceRepeat: TimeInterval = 0.07
    var backspaceDelayTimer: Timer?
    var backspaceRepeatTimer: Timer?
    
    // MARK: -
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadCipherSetting()
        viewModel.viewDidLoad()
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
    
    
    // MARK: -
    // MARK: Magic happen
    
    internal override func bindStyles() {
        super.bindStyles()
        let c = view.heightAnchor.constraint(equalToConstant: LayoutConstraints.keyboardHeight)
        c.priority = UILayoutPriorityDefaultHigh
        c.isActive = true
        keyboardView.heightAnchor.constraint(equalToConstant: LayoutConstraints.keyboardViewHeight).isActive = true
        
        _ = self.topBarLeftView |> UIView.lens.backgroundColor %~ {_ in UIColor.topBarBackgroundColor}
        _ = self.topBarRightView |> UIView.lens.backgroundColor %~ {_ in UIColor.topBarBackgroundColor}
        _ = self.heuristicLabel |> UILabel.lens.textColor %~ {_ in UIColor.topBarInscriptColor}
        _ = self.encryptedLabel |> UILabel.lens.textColor %~ {_ in UIColor.topBarInscriptColor}
        _ = self.leftViewLeftTag |> UILabel.lens.textColor %~ {_ in UIColor.topBarInscriptColor}
        _ = self.rightViewLeftTag |> UILabel.lens.textColor %~ {_ in UIColor.topBarInscriptColor}
        _ = self.cipherLabel |> UILabel.lens.textColor %~ {_ in UIColor.topBarInscriptColor}
    }
}









































