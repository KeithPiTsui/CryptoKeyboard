//
//  CipherSettingView.swift
//  CryptoKeyboard
//
//  Created by Pi on 13/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol CipherSettingViewDelegate: class {
    
    
}


final class CipherSettingView: UIView {

    private lazy var topBar: CipherSettingTopBarView = CipherSettingTopBarView(withDelegate: self)
    private let morseLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Morse")
    private let morseLine: UIView = UIView()
    private let caesarLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Caesar")
    private let caesarLine: UIView = UIView()
    private let vigenereLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Vigenere")
    private let vigenereLine: UIView = UIView()
    private let keywordLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Keyword")
    private let keywordLine: UIView = UIView()
    private let zigzagLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Zigzag")
    private let zigzagLine: UIView = UIView()
    private let cipherSelectSlider: UISlider = UISlider()
    
    /// To record bound change
    private var boundSize: CGSize?
    var delegate: CipherSettingViewDelegate?
    
    init(frame: CGRect = CGRect.zero, withDelegate delegate: CipherSettingViewDelegate? = nil) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        backgroundColor = UIColor.keyboardViewBackgroundColor
        isOpaque = false
        assembleElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (bounds.width != 0 && bounds.height != 0)
            && (boundSize == nil || (bounds.size.equalTo(boundSize!) == false)) {
            boundSize = bounds.size
            layoutUIElements()
        }
    }
    
    private func assembleElements() {
        addSubview(topBar)
        addSubview(morseLabel)
        addSubview(morseLine)
        addSubview(caesarLabel)
        addSubview(caesarLine)
        addSubview(vigenereLabel)
        addSubview(vigenereLine)
        addSubview(keywordLabel)
        addSubview(keywordLine)
        addSubview(zigzagLabel)
        addSubview(zigzagLine)
        addSubview(cipherSelectSlider)
    }
    
    private func layoutUIElements() {
        
    }
    
}


extension CipherSettingView: CipherSettingTopBarViewDelegate {
    
}




















