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


class CipherSettingView: UIView {

    let topBar: CipherSettingTopBarView = CipherSettingTopBarView()
    let morseLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Morse")
    let morseLine: UIView = UIView()
    let caesarLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Caesar")
    let caesarLine: UIView = UIView()
    let vigenereLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Vigenere")
    let vigenereLine: UIView = UIView()
    let keywordLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Keyword")
    let keywordLine: UIView = UIView()
    let zigzagLabel: UILabel = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor, text: "Zigzag")
    let zigzagLine: UIView = UIView()
    let cipherSelectSlider: UISlider = UISlider()
    
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























