//
//  CipherInterpreterViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import Prelude
import Prelude_UIKit
import ExtSwift

class CipherInterpreterViewController: UIViewController {

    var cipherType: CipherType = .caesar
    fileprivate var cipherKey: String {return cipherKeys.joined()}
    private var cipherName: String { return CipherManager.ciphers[cipherType]!.name }
    var cipherKeys:[String] = ["0","3"]
    private var keyDigits: UInt {return CipherManager.ciphers[cipherType]?.digits ?? 0}
    
    
    @IBOutlet weak var plaintextView: UITextView!
    @IBOutlet weak var encryptedTextView: UITextView!
    @IBOutlet weak var tranlateBtn: UIButton!
    @IBOutlet weak var keyStackView: UIStackView!
    @IBOutlet weak var keyEidtBtn: UIButton!
    @IBOutlet weak var midBarView: UIView!
    
    internal static func instantiate() -> CipherInterpreterViewController {
        return Storyboard.CipherInterpreter.instantiate(CipherInterpreterViewController.self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = cipherName

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(CipherInterpreterViewController.keyboardDidShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CipherInterpreterViewController.KeyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(_ notification: Notification){
        guard self.encryptedTextView.isFirstResponder else { return }
        guard view.frame.origin.y == 0 else { return }
//        guard let info = notification.userInfo else { return }
//        guard let kbSizeValue = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
//        let kbSize = kbSizeValue.cgRectValue.size
        let midBarRect = self.midBarView.frame
        let dy = midBarRect.origin.y
            - self.navigationController!.navigationBar.frame.size.height
            - 18
        var rect = view.frame
//        rect.origin.y -= kbSize.height
        rect.origin.y -= dy
        UIView.animate(withDuration: 0.5) {
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

    
    
    
    override func bindStyles() {
        super.bindStyles()
        _ = self.plaintextView |> UITextView.lens.backgroundColor %~ {_ in UIColor(43,181,255)}
        _ = self.plaintextView |> UITextView.lens.font %~ {_ in UIFont.translatorOriginalTextFont}
        _ = self.encryptedTextView |> UITextView.lens.backgroundColor %~ {_ in UIColor(249,252,255)}
        _ = self.encryptedTextView |> UITextView.lens.font %~ {_ in UIFont.translatorOriginalTextFont}
        self.plaintextView.reactive.continuousTextValues.observeValues{[weak self]_ in self?.lastFocusTextView = 0 }
        self.encryptedTextView.reactive.continuousTextValues.observeValues{[weak self]_ in self?.lastFocusTextView = 1 }
    }
    
    
    private func updateStackView() {
        _ = self.keyStackView |> UIStackView.lens.arrangedSubviews %~ { [weak self] _ in
            guard let digits = self?.keyDigits, digits > 0 else { return [] }
            var views = [UIView]()
            for i in 0 ..< digits {
                let label = UILabel()
                label.textAlignment = .center
                if let count = self?.cipherKeys.count, i < UInt(count) {
                    label.text = self?.cipherKeys[Int(i)]
                }
                label.textColor = UIColor.white
                views.append(label)
            }
            return views
        }
    }
    
    
    override func bindViewModel() {
        super.bindViewModel()
        self.tranlateBtn.reactive.controlEvents(.touchUpInside)
            .observeValues{[weak self] _ in
                self?.plaintextView.resignFirstResponder()
                self?.encryptedTextView.resignFirstResponder()
                self?.tranlateButtonGetClick()
            }
        self.keyEidtBtn.reactive.controlEvents(.touchUpInside)
            .observeValues { [weak self] _ in
                self?.plaintextView.resignFirstResponder()
                self?.encryptedTextView.resignFirstResponder()
                self?.slideInKeyboard()
        }
        
    }
    
    private let checkedImage = UIImage(named: "Checked")!
    
    fileprivate func slideInKeyboard() {
        plaintextView.resignFirstResponder()
        encryptedTextView.resignFirstResponder()
        editingKey = true
        delay(0.2){
            switch CipherManager.ciphers[self.cipherType]!.keyType {
            case .letter:
                self.alphabetKeyboardSlideIn()
                self.tranlateBtn.setTitle(nil, for: .normal)
                self.tranlateBtn.setImage(self.checkedImage, for: .normal)
            case .number:
                self.numericKeyboardSlideIn()
                self.tranlateBtn.setTitle(nil, for: .normal)
                self.tranlateBtn.setImage(self.checkedImage, for: .normal)
            case .none: // no need a key
                break
            }
        }
    }
    
    
    // MARK: -
    // MARK: Slide in Numerics Keyboard
    private lazy var numericKeyboard: KeyboardView = {
        let v = KeyboardView()
        v.keyboardDiagram = Keyboard.numberKeyboardDiagram
        v.reactive.controlEvents(.touchUpInside).observeValues { [weak self] in
            self?.handleKeyPressDown($0.0.key)
        }
        return v}()
    private var numericKeyboardSlideIned: Bool = false
    private lazy var numericKeyboardConstraints: [NSLayoutConstraint] = {
        var constraints = [NSLayoutConstraint]()
        constraints.append(self.numericKeyboard.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        constraints.append(self.numericKeyboard.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        constraints.append(self.numericKeyboard.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3))
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
    private lazy var alphabetkeyboard: KeyboardView = {
        let v = KeyboardView()
        v.keyboardDiagram = Keyboard.alphaKeyboardDiagram
        v.reactive.controlEvents(.touchUpInside).observeValues { [weak self] in
            self?.handleKeyPressDown($0.0.key)
        }
        return v}()
    private var alphabetKeyboardSlideIned: Bool = false
    private lazy var alphabetKeyboardConstraints: [NSLayoutConstraint] = {
        var constraints = [NSLayoutConstraint]()
        constraints.append(self.alphabetkeyboard.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        constraints.append(self.alphabetkeyboard.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        constraints.append(self.alphabetkeyboard.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3))
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
        updateStackView()
    }
    
    private var editingKey = false
    
    func tranlateButtonGetClick() {
        if editingKey {
            if cipherKeys.count > 0 {
                tranlateBtn.setImage(nil, for: .normal)
                tranlateBtn.setTitle("⇅", for: .normal)
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
            plaintextView.resignFirstResponder()
            encryptedTextView.resignFirstResponder()
        }
        translateMessage()
    }
    
    private var lastFocusTextView = 0
    
    func translateMessage() {
        if lastFocusTextView == 0 {
            guard let message = plaintextView.text else { return }
            guard let translatedMsg = try? CipherManager.encrypt(message: message, withKey: cipherKey, andCipherType: cipherType) else { return }
            encryptedTextView.text = translatedMsg
        } else {
            guard let message = encryptedTextView.text else { return }
            guard let translatedMsg = try? CipherManager.decrypt(message: message, withKey: cipherKey, andCipherType: cipherType) else { return }
            plaintextView.text = translatedMsg
        }
    }
}


























