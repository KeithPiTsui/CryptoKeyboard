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
    fileprivate var cipherKey: String {return cipherKeys.joined()}
    private var cipherName: String { return CipherManager.ciphers[cipherType]!.name }
    fileprivate var lastFocusTextView: Int = 0
    
    private var layoutConstraints: [NSLayoutConstraint] = []
    private var keyAreaLayoutConstraints: [NSLayoutConstraint] = []
    
    fileprivate var cipherKeys:[String]
    
    private let checkedImage = UIImage(named: "Checked")!
    
    private var editingKey: Bool = false
    
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
    
    private lazy var translateBtn: UIButton = {
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
    
    init(cipherType: CipherType, cipherKey: String) {
        self.cipherType = cipherType
        self.cipherKeys = cipherKey.chars
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(236,248,255)
        
        view.addSubview(wholeArea)
        wholeArea.addSubview(originalArea)
        originalArea.addSubview(originalTextView)
        wholeArea.addSubview(translatedArea)
        translatedArea.addSubview(translatedTextView)
        wholeArea.addSubview(translateBtn)
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
        
        layoutConstraints.append(translateBtn.rightAnchor.constraint(equalTo: wholeArea.rightAnchor, constant:-12))
        layoutConstraints.append(translateBtn.centerYAnchor.constraint(equalTo: wholeArea.centerYAnchor))
        
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
        if editingKey {
            if cipherKeys.count > 0 {
                translateBtn.setImage(nil, for: .normal)
                translateBtn.setTitle("⇅", for: .normal)
                if alphabetkeyboard.superview != nil {
                    alphabetKeyboardSlideOut()
                } else if numericKeyboardSlideIned {
                    numericKeyboardSlideOut()
                }
                editingKey = false
            } else {
                return
            }
        } else {
            originalTextView.resignFirstResponder()
            translatedTextView.resignFirstResponder()
        }
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
    
    
    fileprivate func slideInKeyboard() {
        editingKey = true
        originalTextView.resignFirstResponder()
        translatedTextView.resignFirstResponder()
        delay(0.2){
            switch CipherManager.ciphers[self.cipherType]!.keyType {
            case .letter:
                self.alphabetKeyboardSlideIn()
                self.translateBtn.setTitle(nil, for: .normal)
                self.translateBtn.setImage(self.checkedImage, for: .normal)
            case .number:
                self.numericKeyboardSlideIn()
                self.translateBtn.setTitle(nil, for: .normal)
                self.translateBtn.setImage(self.checkedImage, for: .normal)
            case .none: // no need a key
                break
            }
        }
    }
    
    
    // MARK: -
    // MARK: Slide in Numerics Keyboard
    private lazy var numericKeyboard: NumericKeyboard = {
        let v  = NumericKeyboard(withDelegate: self)
        return v}()
    private var numericKeyboardSlideIned: Bool = false
    private lazy var numericKeyboardConstraints: [NSLayoutConstraint] = {
        var constraints = [NSLayoutConstraint]()
        constraints.append(self.numericKeyboard.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        constraints.append(self.numericKeyboard.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        
        constraints.append(self.numericKeyboard.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3))
        //constraints.append(self.numericKeyboard.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor))
        constraints.append(self.numericKeyboard.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor))
        return constraints
    }()
    
    fileprivate func numericKeyboardSlideIn(){
        view.addSubview(numericKeyboard)
        NSLayoutConstraint.activate(numericKeyboardConstraints)
        numericKeyboardSlideIned = true
    }
    
    private func numericKeyboardSlideOut(){
        NSLayoutConstraint.deactivate(numericKeyboardConstraints)
        numericKeyboard.removeFromSuperview()
        numericKeyboardSlideIned = false
    }
    
    
    
    // MARK: -
    // MARK: Slide in Alphabet Keyboard
    private lazy var alphabetkeyboard: AlphabetKeyboard = {
        let v  = AlphabetKeyboard(withDelegate: self)
        return v}()
    private var alphabetKeyboardSlideIned: Bool = false
    private lazy var alphabetKeyboardConstraints: [NSLayoutConstraint] = {
        var constraints = [NSLayoutConstraint]()
        constraints.append(self.alphabetkeyboard.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        constraints.append(self.alphabetkeyboard.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        constraints.append(self.alphabetkeyboard.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3))
        //constraints.append(self.alphabetkeyboard.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor))
        constraints.append(self.alphabetkeyboard.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor))
        return constraints
    }()
    
    fileprivate func alphabetKeyboardSlideIn(){
        view.addSubview(alphabetkeyboard)
        NSLayoutConstraint.activate(alphabetKeyboardConstraints)
        alphabetKeyboardSlideIned = true
    }
    
    private func alphabetKeyboardSlideOut(){
        NSLayoutConstraint.deactivate(alphabetKeyboardConstraints)
        alphabetkeyboard.removeFromSuperview()
        alphabetKeyboardSlideIned = false
    }
    
    fileprivate func handleKeyPressDown(_ key: Key) {
        if key.type == .alphabet || key.type == .number {
            guard cipherKeys.count < Int(CipherManager.ciphers[cipherType]!.digits) else { return }
            let letter = key.outputForCase(false)
            cipherKeys.append(letter)
        } else if key.type == .backspace {
            guard cipherKeys.isEmpty == false else { return }
            cipherKeys.removeLast()
        }
        keyArea.reloadValues()
    }
}


extension CipherTranslatorViewController: CipherSettingTopBarViewDelegate {
    func valuesForDisplay() -> [String] {
        return cipherKeys
    }
    func getTouched() {
        print("\(#function)")
        slideInKeyboard()
        
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
        if tv.text.characters.count > 1 {
            let start = tv.text.index(before: tv.text.endIndex)
            let startLocation = tv.text.distance(from: tv.text.startIndex, to: start)
            let length = tv.text.distance(from: start, to: tv.text.endIndex)
            tv.scrollRangeToVisible(NSMakeRange(startLocation, length))
        }
    }
}



extension CipherTranslatorViewController: AlphabetKeyboardDelegate {
    func keyboardViewItem(_ item: KeyboardViewItem, receivedEvent event: UIControlEvents, inKeyboard keyboard: AlphabetKeyboard) {
        print("\(#function)")
        
        if event == .touchUpInside {
            handleKeyPressDown(item.key)
        }
    }
    
    
}

//NumericKeyboardDelegate
extension CipherTranslatorViewController: NumericKeyboardDelegate {
    func nKeyboardViewItem(_ item: KeyboardViewItem, receivedEvent event: UIControlEvents, inKeyboard keyboard: NumericKeyboard) {
        print("\(#function)")
        if event == .touchUpInside {
            handleKeyPressDown(item.key)
        }
        
    }
}






















