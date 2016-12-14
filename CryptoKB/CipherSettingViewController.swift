//
//  CipherSettingViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 14/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol CipherSettingViewControllerDelegate: class {
    
}

extension UIView {
    static func cipherSettingLineView(lineWidth width: CGFloat, lineColor color: UIColor) -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: width).isActive = true
        v.backgroundColor = color
        v.layer.cornerRadius = 3
        v.clipsToBounds = true
        return v
    }
}

class CipherSettingViewController: UIViewController {

    weak var delegate: CipherSettingViewControllerDelegate?
    
    lazy var cancelBtn: UIBarButtonItem = {
        let img = UIImage(named: "backArrow")!
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(CipherSettingViewController.cancel))
        return item
    }()
    
    lazy var doneBtn: UIBarButtonItem = {
        let img = UIImage(named: "checkedSymbol")!
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(CipherSettingViewController.done))
        item.tintColor = UIColor.barCheckedSymbolColor
        return item
    }()
    
    lazy var cipherTopBar: CipherSettingTopBarView = {
        let tb = CipherSettingTopBarView(withDelegate: self)
        tb.frame = CGRect(0, 0, 150, 50)
        return tb
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = doneBtn
        navigationItem.titleView = cipherTopBar
        assembleElements()
        layoutElements()
    }
    
    func cancel() {
        print("\(#function)")
        if alphabetKeyboardSlideIned {
            alphabetKeyboardSlideOut()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func done() {
        print("\(#function)")
        dismiss(animated: true, completion: nil)
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
        constraints.append(self.alphabetkeyboard.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor))
        constraints.append(self.alphabetkeyboard.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor))
        return constraints
    }()
    
    fileprivate func alphabetkeyboardSlideIn(){
        view.addSubview(alphabetkeyboard)
        NSLayoutConstraint.activate(alphabetKeyboardConstraints)
        alphabetKeyboardSlideIned = true
    }
    
    private func alphabetKeyboardSlideOut(){
        NSLayoutConstraint.deactivate(alphabetKeyboardConstraints)
        alphabetkeyboard.removeFromSuperview()
        alphabetKeyboardSlideIned = false
    }
    
    
    
    
    // MARK: -
    // MARK: primary UI Elements and Layout
    
    private let morseLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Morse")
    private let morseLine: UIView = UIView.cipherSettingLineView(lineWidth: 5, lineColor: UIColor.white)
    private let caesarLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Caesar")
    private let caesarLine: UIView = UIView.cipherSettingLineView(lineWidth: 5, lineColor: UIColor.white)
    private let vigenereLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Vigenere")
    private let vigenereLine: UIView = UIView.cipherSettingLineView(lineWidth: 5, lineColor: UIColor.white)
    private let keywordLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Keyword")
    private let keywordLine: UIView = UIView.cipherSettingLineView(lineWidth: 5, lineColor: UIColor.white)
    private let cipherSelectSlider: UISlider = {let v = UISlider(); v.translatesAutoresizingMaskIntoConstraints = false; v.backgroundColor = UIColor.lightGray; return v}()
    
    private func assembleElements () {
        view.addSubview(morseLabel)
        view.addSubview(morseLine)
        view.addSubview(caesarLabel)
        view.addSubview(caesarLine)
        view.addSubview(vigenereLabel)
        view.addSubview(vigenereLine)
        view.addSubview(keywordLabel)
        view.addSubview(keywordLine)
        view.addSubview(cipherSelectSlider)
    }
    
    private func layoutElements() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: morseLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 2*1/5, constant: 0))
        constraints.append(NSLayoutConstraint(item: morseLabel, attribute: .bottom, relatedBy: .equal, toItem: caesarLabel, attribute: .top, multiplier: 1, constant: -2))
        
        constraints.append(NSLayoutConstraint(item: morseLine, attribute: .top, relatedBy: .equal, toItem: morseLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: morseLine, attribute: .centerX, relatedBy: .equal, toItem: morseLabel, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: morseLine, attribute: .bottom, relatedBy: .equal, toItem: cipherSelectSlider, attribute: .top, multiplier: 1, constant: -2))
        
        constraints.append(NSLayoutConstraint(item: caesarLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 2*2/5, constant: 0))
        constraints.append(NSLayoutConstraint(item: caesarLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 2*2/4, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: caesarLine, attribute: .top, relatedBy: .equal, toItem: caesarLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: caesarLine, attribute: .centerX, relatedBy: .equal, toItem: caesarLabel, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: caesarLine, attribute: .bottom, relatedBy: .equal, toItem: cipherSelectSlider, attribute: .top, multiplier: 1, constant: -2))
        
        constraints.append(NSLayoutConstraint(item: vigenereLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 2*3/5, constant: 0))
        constraints.append(NSLayoutConstraint(item: vigenereLabel, attribute: .bottom, relatedBy: .equal, toItem: keywordLabel, attribute: .top, multiplier: 1, constant: -2))
        
        constraints.append(NSLayoutConstraint(item: vigenereLine, attribute: .top, relatedBy: .equal, toItem: vigenereLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: vigenereLine, attribute: .centerX, relatedBy: .equal, toItem: vigenereLabel, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: vigenereLine, attribute: .bottom, relatedBy: .equal, toItem: cipherSelectSlider, attribute: .top, multiplier: 1, constant: -2))
        
        constraints.append(NSLayoutConstraint(item: keywordLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 2*4/5, constant: 0))
        constraints.append(NSLayoutConstraint(item: keywordLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 2*2/4, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: keywordLine, attribute: .top, relatedBy: .equal, toItem: keywordLabel, attribute: .bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: keywordLine, attribute: .centerX, relatedBy: .equal, toItem: keywordLabel, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: keywordLine, attribute: .bottom, relatedBy: .equal, toItem: cipherSelectSlider, attribute: .top, multiplier: 1, constant: -2))
        
        constraints.append(NSLayoutConstraint(item: cipherSelectSlider, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: cipherSelectSlider, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 2*3/4, constant: 0))
        constraints.append(NSLayoutConstraint(item: cipherSelectSlider, attribute: .left, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: cipherSelectSlider, attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
}


extension CipherSettingViewController: CipherSettingTopBarViewDelegate {
    func valuesForDisplay() -> [String] {
        return ["A","B","C","D","E","F"]
    }
    
    func getTouched() {
        print("\(#function)")
        alphabetkeyboardSlideIn()
    }
}

extension CipherSettingViewController: AlphabetKeyboardDelegate {
    func keyboardViewItem(_ item: KeyboardViewItem, receivedEvent event: UIControlEvents, inKeyboard keyboard: AlphabetKeyboard) {
        print("\(#function)")
    }
}



