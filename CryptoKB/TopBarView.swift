//
//  TopBarView.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit


protocol TopBarViewDelegate {
     func topBarLabel(_ label: UILabel, receivedEvent event: UIControlEvents, inTopBar topBar: TopBarView)
}

class TopBarView: UIView {
    var leftLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.font = label.font.withSize(20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textColor = UIColor.keyboardViewItemInscriptColor
        return label
    }()

    var middleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.font = label.font.withSize(20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textColor = UIColor.keyboardViewItemInscriptColor
        
        return label
    }()

    var rightLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.font = label.font.withSize(20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textColor = UIColor.keyboardViewItemInscriptColor
        return label
    }()

    var delegate: TopBarViewDelegate?
    var touchToView: [UITouch:UIView] = [:]
    
    init(frame: CGRect = CGRect.zero, delegate: TopBarViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        assembleUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func assembleUIElements () {
        addSubview(leftLabel)
        addSubview(middleLabel)
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
                                                                 multiplier: 1/3,
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
        
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: middleLabel,
                                                                 attribute: .height,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .height,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: middleLabel,
                                                                 attribute: .width,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .width,
                                                                 multiplier: 1/3,
                                                                 constant: -1))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: middleLabel,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: self,
                                                                 attribute: .top,
                                                                 multiplier: 1,
                                                                 constant: 0))
        keyboradViewLayoutConstraints.append( NSLayoutConstraint(item: middleLabel,
                                                                 attribute: .left,
                                                                 relatedBy: .equal,
                                                                 toItem: leftLabel,
                                                                 attribute: .right,
                                                                 multiplier: 1,
                                                                 constant: 1))
        
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
                                                                 toItem: middleLabel,
                                                                 attribute: .right,
                                                                 multiplier: 1,
                                                                 constant: 1))
        
        self.addConstraints(keyboradViewLayoutConstraints)
    }
    
    func resetLabels() {
        for label in [leftLabel, middleLabel, rightLabel] {
            label.text = nil
        }
    }
}












