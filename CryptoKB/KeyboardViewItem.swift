//
//  KeyboardItemView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class KeyboardViewItem: UIView {
    
    var key: Key! { didSet {installKey()} }

    override var description: String { return super.description + key.description }
    
    var boundSize: CGSize?
    
    var popup: UIView?
    
    lazy var inscriptLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.font = KeyboardAppearanceScheme.keyboardViewItemInscriptFont
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
            iv.color = UIColor.shiftIconDrawingColor
        case .backspace:
            iv = BackspaceIconView()
        case .keyboardChange:
            iv = GlobeIconView()
            iv.color = UIColor.globalDrawingColor
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
//        layer.shadowOffset = CGSize(width: 2, height: 2)
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowOpacity = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if (bounds.width != 0 && bounds.height != 0) && (boundSize == nil || (bounds.size.equalTo(boundSize!) == false)) {
            layoutItem()
        }
    }
    
    private func layoutItem() {
        if key.withIcon {
            iconView.frame = CGRect(x: 4, y: 4, width: bounds.width - 8, height: bounds.height - 8)
            iconView.setNeedsDisplay()
        } else {
            inscriptLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        }
    }
    
    private func installKey() {
        for v in subviews {
            v.removeFromSuperview()
        }
        if key.withIcon {
            addSubview(iconView)
        } else {
            addSubview(inscriptLabel)
            inscriptLabel.text = (GlobalKeyboardViewController.shiftState.isUppercase ? key.uppercaseKeyCap : key.lowercaseKeyCap) ?? "\(key.hashValue)"
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(KeyboardViewItem.updateViewItemInscript(_:)),
                                                   name: KeyboardViewController.shiftStateChangedNotification,
                                                   object: nil)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func updateViewItemInscript(_ notification: Notification) {
        if key.withIcon == false {
            inscriptLabel.text = (GlobalKeyboardViewController.shiftState.isUppercase ? key.uppercaseKeyCap : key.lowercaseKeyCap) ?? "\(key.hashValue)"
        }
    }
    
    /// Item Popup
    func showPopup() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = UIColor.keyboardViewItemHighlightedBackgroundColor
        }
        
    }
    
    func hidePopup() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = UIColor.keyboardViewItemBackgroundColor
        }
    }
    
    /// Item Highlight
    func highlightItem() {

    }
    
    func unhighlightItem() {
        
    }
    
    func shiftEnable() {
        guard key.type == .shift else { return }
        UIView.animate(withDuration: 0.1) {
            self.iconView.color = UIColor.shiftIconHighlightDrawingColor
            self.layer.borderWidth = 0
        }
    }
    
    func shiftDisable() {
        guard key.type == .shift else { return }
        UIView.animate(withDuration: 0.1) {
            self.iconView.color = UIColor.shiftIconDrawingColor
            self.layer.borderWidth = 0
        }
    }
    
    func shiftLocked() {
        guard key.type == .shift, let shiftView = iconView as? ShiftIconView else { return }
        UIView.animate(withDuration: 0.1) {
            shiftView.color = UIColor.shiftIconHighlightDrawingColor
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.shiftIconHighlightDrawingColor.cgColor
        }
    }
    
}





























