//
//  KeyboardItemView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class KeyboardViewItem: UIControl {
    
    var key: Key! { didSet {installKey()} }

    override var description: String { return super.description + key.description }
    
    //
    lazy var inscriptLabel: UILabel = {
        let label = UILabel()
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
    
    lazy var iconView: IconDrawingView! = {
        var iv: IconDrawingView! = nil
        switch self.key.type {
        case .shift:
            iv = ShiftIconView()
        case .backspace:
            iv = BackspaceIconView()
        case .keyboardChange:
            iv = GlobeIconView()
        default:
            break
        }
        return iv
    }()
    
    init(frame: CGRect = CGRect.zero, key: Key? = nil) {
        self.key = key
        super.init(frame: frame)
        backgroundColor = UIColor.keyboardViewItemBackgroundColor
        layer.cornerRadius = 6
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    override func layoutSubviews() {
        
        print("\(#function) Keyboard View Super view frame: \(superview?.frame)")
        print("\(#function) Keyboard View Super view frame: \(frame)")
        
        if key.withIcon {
            iconView.frame = CGRect(x: 4, y: 4, width: frame.width - 8, height: frame.height - 8)
            iconView.setNeedsLayout()
        } else {
            inscriptLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }
        super.layoutSubviews()
        
        print("\(#function) layout completed")
    }
    
    private func installKey() {
        for v in subviews {
            v.removeFromSuperview()
        }
        if key.withIcon {
            addSubview(iconView)
        } else {
            addSubview(inscriptLabel)
            inscriptLabel.text = key.lowercaseKeyCap ?? "\(key.hashValue)"
        }
    }
    
}





























