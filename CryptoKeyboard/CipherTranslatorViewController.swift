//
//  CipherTranslatorViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

class CipherTranslatorViewController: UIViewController {
    
    private var cipherType: CipherType = .caesar
    fileprivate var cipherKey: String = "03"
    private var cipherName: String { return CipherManager.ciphers[cipherType]!.name }
    fileprivate var lastFocusTextView: Int = 0
    
    private var layoutConstraints: [NSLayoutConstraint] = []
    private var keyAreaLayoutConstraints: [NSLayoutConstraint] = []
    
    private lazy var wholeArea: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 6
        return v
    }()
    
    private lazy var originalArea: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(43,181,255)
        return v
    }()
    
    fileprivate lazy var originalTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.text = "Hello"
        tv.textColor = UIColor(249,252,255)
        tv.font = UIFont.translatorOriginalTextFont
        tv.delegate = self
        return tv
    }()
    
    private lazy var translatedArea: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(249,252,255)
        return v
    }()
    
    fileprivate lazy var translatedTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.text = "Hola"
        tv.textColor = UIColor(43,181,255)
        tv.font = UIFont.translatorOriginalTextFont
        tv.delegate = self
        return tv
    }()
    
    private lazy var tranlateBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.roundedRect)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("⇅", for: .normal)
        btn.backgroundColor = UIColor.white
        btn.alpha = 0.8
        btn.layer.cornerRadius = 6
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = CGSize(1,1)
        btn.addTarget(self, action: #selector(CipherTranslatorViewController.tranlateButtonGetClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var keyArea: CipherSettingTopBarView = {
        let v = CipherSettingTopBarView(withDelegate: self)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        v.alpha = 0.8
        v.layer.cornerRadius = 6
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(1,1)
        
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(236,248,255)
        
        view.addSubview(wholeArea)
        wholeArea.addSubview(originalArea)
        originalArea.addSubview(originalTextView)
        wholeArea.addSubview(translatedArea)
        translatedArea.addSubview(translatedTextView)
        wholeArea.addSubview(tranlateBtn)
        wholeArea.addSubview(keyArea)
        
        assembleConstraints()
        NSLayoutConstraint.activate(layoutConstraints)
        NSLayoutConstraint.activate(keyAreaLayoutConstraints)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    private func assembleConstraints() {
        layoutConstraints.removeAll(keepingCapacity: true)
        keyAreaLayoutConstraints.removeAll(keepingCapacity: true)
        layoutConstraints.append(wholeArea.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
        layoutConstraints.append(wholeArea.leftAnchor.constraint(equalTo: view.leftAnchor))
        layoutConstraints.append(wholeArea.rightAnchor.constraint(equalTo: view.rightAnchor))
        layoutConstraints.append(wholeArea.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor))
        
        layoutConstraints.append(originalArea.leftAnchor.constraint(equalTo: wholeArea.leftAnchor))
        layoutConstraints.append(originalArea.rightAnchor.constraint(equalTo: wholeArea.rightAnchor))
        layoutConstraints.append(originalArea.topAnchor.constraint(equalTo: wholeArea.topAnchor))
        layoutConstraints.append(originalArea.heightAnchor.constraint(equalTo: wholeArea.heightAnchor, multiplier: 0.5))
        
        layoutConstraints.append(translatedArea.leftAnchor.constraint(equalTo: wholeArea.leftAnchor))
        layoutConstraints.append(translatedArea.rightAnchor.constraint(equalTo: wholeArea.rightAnchor))
        layoutConstraints.append(translatedArea.bottomAnchor.constraint(equalTo: wholeArea.bottomAnchor))
        layoutConstraints.append(translatedArea.topAnchor.constraint(equalTo: originalArea.bottomAnchor))
        
        layoutConstraints.append(originalTextView.leftAnchor.constraint(equalTo: originalArea.leftAnchor, constant: 16))
        layoutConstraints.append(originalTextView.rightAnchor.constraint(equalTo: originalArea.rightAnchor, constant: -16))
        layoutConstraints.append(originalTextView.topAnchor.constraint(equalTo: originalArea.topAnchor, constant: 32))
        layoutConstraints.append(originalTextView.bottomAnchor.constraint(equalTo: originalArea.bottomAnchor, constant: -32))
        
        layoutConstraints.append(translatedTextView.leftAnchor.constraint(equalTo: translatedArea.leftAnchor, constant: 16))
        layoutConstraints.append(translatedTextView.rightAnchor.constraint(equalTo: translatedArea.rightAnchor, constant: -16))
        layoutConstraints.append(translatedTextView.topAnchor.constraint(equalTo: translatedArea.topAnchor, constant: 8))
        layoutConstraints.append(translatedTextView.bottomAnchor.constraint(equalTo: translatedArea.bottomAnchor, constant: -8))
        
        layoutConstraints.append(tranlateBtn.rightAnchor.constraint(equalTo: wholeArea.rightAnchor, constant:-12))
        layoutConstraints.append(tranlateBtn.centerYAnchor.constraint(equalTo: wholeArea.centerYAnchor))
        
        if cipherKey.chars.count > 0 {
            keyAreaLayoutConstraints.append(keyArea.heightAnchor.constraint(equalToConstant: 30))
            keyAreaLayoutConstraints.append(keyArea.widthAnchor.constraint(equalTo: wholeArea.widthAnchor, multiplier: 0.4))
            keyAreaLayoutConstraints.append(keyArea.leftAnchor.constraint(equalTo: wholeArea.leftAnchor, constant:12))
            keyAreaLayoutConstraints.append(keyArea.centerYAnchor.constraint(equalTo: wholeArea.centerYAnchor))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        translateMessage()
    }
    
    func tranlateButtonGetClick() {
        originalTextView.resignFirstResponder()
        translatedTextView.resignFirstResponder()
        translateMessage()
    }
    
    func translateMessage() {
        if lastFocusTextView == 0 {
            guard let message = originalTextView.text else { return }
            guard let translatedMsg = try? CipherManager.encrypt(message: message, withKey: cipherKey, andCipherType: cipherType) else { return }
            translatedTextView.text = translatedMsg
        } else {
            guard let message = translatedTextView.text else { return }
            guard let translatedMsg = try? CipherManager.decrypt(message: message, withKey: cipherKey, andCipherType: cipherType) else { return }
            originalTextView.text = translatedMsg
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(CipherTranslatorViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CipherTranslatorViewController.KeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(_ notification: Notification){
        guard view.frame.origin.y == 0 else { return }
        guard let info = notification.userInfo else { return }
        guard let kbSizeValue = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let kbSize = kbSizeValue.cgRectValue.size
        var rect = view.frame
        rect.origin.y -= kbSize.height
        UIView.animate(withDuration: 0.3) {
            self.view.frame = rect
            self.view.setNeedsLayout()
        }
    }
    
    func KeyboardWillHide(_ notification: Notification){
        guard view.frame.origin.y < 0 else { return }
        var rect = view.frame
        rect.origin.y = 0
        UIView.animate(withDuration: 0.3) {
            self.view.frame = rect
            self.view.setNeedsLayout()
        }
    }
    
}


extension CipherTranslatorViewController: CipherSettingTopBarViewDelegate {
    func valuesForDisplay() -> [String] {
        return cipherKey.chars
    }
    func getTouched() {
        print("\(#function)")
    }
}

extension CipherTranslatorViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView){
        var tv = textView
        if textView === originalTextView {
            lastFocusTextView = 0
            tv = translatedTextView
        } else {
            lastFocusTextView = 1
            tv = originalTextView
        }
        translateMessage()
        
        
        
        let start = tv.text.index(before: tv.text.endIndex)
        let startLocation = tv.text.distance(from: tv.text.startIndex, to: start)
        let length = tv.text.distance(from: start, to: tv.text.endIndex)
        tv.scrollRangeToVisible(NSMakeRange(startLocation, length))
        
    }
}

























