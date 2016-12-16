//
//  CipherSettingViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 14/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol CipherSettingViewControllerDelegate: class {
    func didSelect(cipherName: String, cipherType: CipherType, cipherKey: String)
    func cancelSelect()
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

final class CipherSettingViewController: UIViewController {

    weak var delegate: CipherSettingViewControllerDelegate?
    
    private lazy var cancelBtn: UIBarButtonItem = {
        let img = UIImage(named: "backArrow")!
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(CipherSettingViewController.cancel))
        return item
    }()
    
    private lazy var doneBtn: UIBarButtonItem = {
        let img = UIImage(named: "checkedSymbol")!
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(CipherSettingViewController.done))
        item.tintColor = UIColor.barCheckedSymbolColor
        return item
    }()
    
    fileprivate lazy var cipherTopBar: CipherSettingTopBarView = {
        let tb = CipherSettingTopBarView(withDelegate: self)
        tb.frame = CGRect(0, 0, 150, 50)
        return tb
    }()
    
    private let originalCipherType: CipherType
    private let originalCipherKey: [String]
    

    fileprivate var cipherType: CipherType {didSet{highlightSelectedLabel()}}
    
    
    fileprivate lazy var cipherKeys:[[String]] = [[""],[""],[""],[""]]
    
    private lazy var cipherTypes: [CipherType] = [.morse, .caesar, .vigenere, .keyword]
    
    fileprivate var cipherIndex: Int {
        return self.cipherTypes.index(of: self.cipherType)!
    }
    
    private func cipherName() -> String {
        return CipherManager.ciphers[cipherType]!.name
    }
    
    fileprivate func cipherKey() -> String {
        return cipherKeys[cipherTypes.index(of: cipherType)!].joined()
    }
    
    fileprivate var cipherUpdated: Bool {
        return originalCipherKey != self.cipherKeys[cipherTypes.index(of: cipherType)!]
            || originalCipherType != cipherType
    }
    
    private func updateCipherKey() {
        
    }
    
    private func highlightSelectedLabel() {
        [morseLabel, caesarLabel, vigenereLabel,keywordLabel].forEach{$0.textColor = UIColor.white}
        [caesarLine, keywordLine, morseLine,vigenereLine].forEach{$0.backgroundColor = UIColor.white}
        UIView.animate(withDuration: 0.2) {
            switch self.cipherType {
            case .caesar:
                self.caesarLabel.textColor = UIColor.red
                self.caesarLine.backgroundColor = UIColor.red
            case .keyword:
                self.keywordLabel.textColor = UIColor.red
                self.keywordLine.backgroundColor = UIColor.red
            case .morse:
                self.morseLabel.textColor = UIColor.red
                self.morseLine.backgroundColor = UIColor.red
            case .vigenere:
                self.vigenereLabel.textColor = UIColor.red
                self.vigenereLine.backgroundColor = UIColor.red
            }
        }
    }
    
    
    init(cipherName: String, cipherType: CipherType, cipherKey: String) {
        originalCipherType = cipherType
        originalCipherKey = cipherKey.chars
        self.cipherType = cipherType
        super.init(nibName: nil, bundle: nil)
        for (idx, ct) in cipherTypes.enumerated() {
            cipherKeys[idx] = ct == cipherType ? cipherKey.chars : (0..<CipherManager.ciphers[ct]!.digits).reduce([]){$0.0+[" "]}
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelBtn
        //navigationItem.rightBarButtonItem = doneBtn
        navigationItem.titleView = cipherTopBar
        assembleElements()
        layoutElements()
    }
    
    func cancel() {
        print("\(#function)")
        if alphabetKeyboardSlideIned {
            alphabetKeyboardSlideOut()
        } else if numericKeyboardSlideIned {
            numericKeyboardSlideOut()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func done() {
        print("\(#function)")
        if cipherUpdated {
            delegate?.didSelect(cipherName: cipherName(), cipherType: cipherType, cipherKey: cipherKey())
        }
        dismiss(animated: true, completion: nil)
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
        constraints.append(self.numericKeyboard.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor))
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
        constraints.append(self.alphabetkeyboard.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor))
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
    
    
    
    
    // MARK: -
    // MARK: primary UI Elements and Layout
    
   private lazy var morseLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Morse")
    private lazy var morseLine: UIView = UIView.cipherSettingLineView(lineWidth: 5, lineColor: UIColor.white)
    private lazy var caesarLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Caesar")
    private lazy var caesarLine: UIView = UIView.cipherSettingLineView(lineWidth: 5, lineColor: UIColor.white)
    private lazy var vigenereLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Vigenere")
    private lazy var vigenereLine: UIView = UIView.cipherSettingLineView(lineWidth: 5, lineColor: UIColor.white)
    private lazy var keywordLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Keyword")
    private lazy var keywordLine: UIView = UIView.cipherSettingLineView(lineWidth: 5, lineColor: UIColor.white)
    
    private lazy var locations:[Float] = [13.5274,38.3562,62.3288,86.8151]
    private lazy var ranges: [Range<Float>] = [0..<25.9418, 25.9418..<50.3425, 50.3425..<74.5720, 74.5720..<100.1]
    private var lastStep: Float = 0
    
    private lazy var cipherSelectSlider: UISlider = {
        let v = UISlider()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.clear
        let leftTrack = UIImage(named:"brightnessBar")!
        let rightTrack = leftTrack
        let cursor = UIImage(named: "cursorThumb")!
        v.minimumValue = 0
        v.maximumValue = 100
        v.setMinimumTrackImage(leftTrack, for: .normal)
        v.setMaximumTrackImage(rightTrack, for: .normal)
        v.setThumbImage(cursor, for: .normal)
        return v
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        highlightSelectedLabel()
    }
    
    
    func sliderValueChanged(sender: UISlider) {
        print("\(#function): \(sender.value)")
        guard let idx  = (ranges.index{$0.contains(sender.value)}) else { return }
        sender.value = locations[idx]
    }
    
    func sliderDragUp(sender: UISlider) {
        print("\(#function): \(sender.value)")
        guard let idx  = (ranges.index{$0.contains(sender.value)}) else { return }
        cipherType = cipherTypes[idx]
        cipherTopBar.reloadValues()
        slideInKeyboard()
    }
    
    private func slideInKeyboard() {
        switch CipherManager.ciphers[cipherType]!.keyType {
        case .letter:
            alphabetKeyboardSlideIn()
        case .number:
            numericKeyboardSlideIn()
        }
    }
    
    
    private func assembleElements () {
        [morseLabel, morseLine, caesarLabel, caesarLine, vigenereLabel, vigenereLine, keywordLabel, keywordLine, cipherSelectSlider].forEach(view.addSubview)
        
        if let idx = cipherTypes.index(of: cipherType) {
            cipherSelectSlider.value = locations[idx]
        }
        
        cipherSelectSlider.addTarget(self, action: #selector(CipherSettingViewController.sliderDragUp(sender:)), for: .touchUpInside)
        cipherSelectSlider.addTarget(self, action: #selector(CipherSettingViewController.sliderValueChanged(sender:)), for: .valueChanged)
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
        return self.cipherKey().chars
    }
    
    func getTouched() {
        print("\(#function)")
        numericKeyboardSlideIn()
    }
}

extension CipherSettingViewController: AlphabetKeyboardDelegate {
    func keyboardViewItem(_ item: KeyboardViewItem, receivedEvent event: UIControlEvents, inKeyboard keyboard: AlphabetKeyboard) {
        print("\(#function)")
        
        if event == .touchUpInside {
            if item.key.type == .alphabet {
                let letter = item.key.outputForCase(false)
                var letters = cipherKeys[cipherIndex]
                if let idx = letters.index(of: " ") {
                    letters[idx] = letter
                }
                cipherKeys[cipherIndex] = letters
            } else if item.key.type == .backspace {
                var letters = cipherKeys[cipherIndex]
                if var idx = letters.index(of: " "), idx != letters.startIndex{
                    idx = letters.index(before: idx)
                    letters[idx] = " "
                } else {
                    letters[letters.index(before: letters.endIndex)] = " "
                }
                cipherKeys[cipherIndex] = letters
            }
            cipherTopBar.reloadValues()
        }
    }
}

//NumericKeyboardDelegate
extension CipherSettingViewController: NumericKeyboardDelegate {
    func nKeyboardViewItem(_ item: KeyboardViewItem, receivedEvent event: UIControlEvents, inKeyboard keyboard: NumericKeyboard) {
        print("\(#function)")
        
    }
}
































