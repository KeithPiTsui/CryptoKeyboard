//
//  TopBarView.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit



fileprivate func assembleLabel(_ label: UILabel, leftTag: UILabel? = nil, rightTag: UILabel? = nil) {
    if let leftTag = leftTag {
        label.addSubview(leftTag)
        var constraints = [NSLayoutConstraint]()
        constraints.append( NSLayoutConstraint(item: leftTag,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: label,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0))
        constraints.append( NSLayoutConstraint(item: leftTag,
                                               attribute: .left,
                                               relatedBy: .equal,
                                               toItem: label,
                                               attribute: .left,
                                               multiplier: 1,
                                               constant: 0))
        label.addConstraints(constraints)
    }
    if let rightTag = rightTag {
        label.addSubview(rightTag)
        var constraints = [NSLayoutConstraint]()
        constraints.append( NSLayoutConstraint(item: rightTag,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: label,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0))
        constraints.append( NSLayoutConstraint(item: rightTag,
                                               attribute: .right,
                                               relatedBy: .equal,
                                               toItem: label,
                                               attribute: .right,
                                               multiplier: 1,
                                               constant: 0))
        label.addConstraints(constraints)
    }
}

protocol TopBarViewDelegate {
     func topBarLabel(_ label: UILabel, receivedEvent event: UIControlEvents, inTopBar topBar: TopBarView)
}

class TopBarView: UIView {
    
    lazy var leftLabel: UILabel = {
        let label = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.topBarInscriptFont, textColor: UIColor.topBarInscriptColor)
        assembleLabel(label, leftTag: self.leftLabelLeftCornerTag)
        return label
    }()
    lazy var leftLabelLeftCornerTag: UILabel = {
        let label =  UILabel.keyboardLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont, textColor: UIColor.topBarInscriptColor, text: "plaintext")
        return label
    }()
    
    

    lazy var middleLabel: UILabel = {
        let label = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.topBarInscriptFont, textColor: UIColor.topBarInscriptColor)
        assembleLabel(label, leftTag: self.middleLabelLeftCornerTag)
        return label
    }()
    lazy var middleLabelLeftCornerTag: UILabel = {
        let label = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont, textColor: UIColor.topBarInscriptColor, text: self.cipherName)
        return label
    }()
    
    
    lazy var rightLabel: UILabel = {
        let label = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.topBarInscriptFont, textColor: UIColor.topBarInscriptColor)
        assembleLabel(label, leftTag: self.rightLabelLeftCornerTag, rightTag: self.rightLabelRightCornerTag)
        return label
    }()
    lazy var rightLabelLeftCornerTag: UILabel = {
        let label = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont, textColor: UIColor.topBarInscriptColor, text: "Secret")
        return label
    }()
    
    lazy var rightLabelRightCornerTag: UILabel = {
        let label = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.topBarTagInscriptFont, textColor: UIColor.topBarInscriptColor, text: self.cipherName)
        return label
    }()

    var cipherName = "Morse" {didSet{rightLabelRightCornerTag.text = cipherName}}
    
    var delegate: TopBarViewDelegate?
    
    var touchToView: [UITouch:UIView] = [:]
    var leftCharacters: [String] = [] {didSet{updateLeftLabelText()}}
    var rightCharacters: [String] = [] {didSet{updateRightLabeText()}}
    
    private func updateLeftLabelText(){
        leftLabel.text = leftCharacters.reduce(""){$0+$1}
    }
    
    private func updateRightLabeText(){
        rightLabel.text = rightCharacters.reduce(""){$0+$1}
    }
    
    
    init(frame: CGRect = CGRect.zero, delegate: TopBarViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        backgroundColor = UIColor.topBarBackgroundColor
        assembleUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func assembleUIElements () {
        addSubview(leftLabel)
        addSubview(rightLabel)
        var keyboradViewLayoutConstraints = [NSLayoutConstraint]()
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: leftLabel,
                                                                 attribute: .height,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .height,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: leftLabel,
                                                                 attribute: .width,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .width,
                                                                 multiplier: 1/2,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: leftLabel,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .top,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: leftLabel,
                                                                 attribute: .left,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .left,
                                                                 multiplier: 1,
                                                                 constant: 0))
        
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: rightLabel,
                                                                 attribute: .height,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .height,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: rightLabel,
                                                                 attribute: .right,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .right,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: rightLabel,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .top,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: rightLabel,
                                                                 attribute: .left,
                                                                 relatedBy: .equal,
                                                                 toItem: leftLabel,
                                                                 attribute: .right,
                                                                 multiplier: 1,
                                                                 constant: 1))
        self.addConstraints(keyboradViewLayoutConstraints)
    }
    
    func resetLabels() {
        leftCharacters.removeAll(keepingCapacity: true)
        rightCharacters.removeAll(keepingCapacity: true)
    }
}












