//
//  KeyboardItemView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

final class KeyboardViewItem: UIView {
    private static func iconDrawingView(keyType type: Key.KeyType) -> IconDrawingView {
        var iv: IconDrawingView! = nil
        switch type {
        case .shift:
            iv = ShiftIconView()
            iv.color = UIColor.shiftIconDrawingColor
        case .backspace:
            let bv = BackspaceIconView()
            bv.color = UIColor.backspaceFillColor
            bv.inscriptColor = UIColor.backspaceInscriptColor
            iv = bv
        case .keyboardChange:
            iv = GlobeIconView()
            iv.color = UIColor.globalDrawingColor
        case .settings:
            iv = SettingIconView()
            iv.color = UIColor.globalDrawingColor
        case .return:
            iv = ReturnIconView()
            iv.color = UIColor.globalDrawingColor
        default:
            break
        }
        return iv
    }
    override var description: String { return super.description + key.description }
    
    var key: Key! { didSet {installKey()} }
    private var boundSize: CGSize?
    
    lazy var inscriptLabel: UILabel = {
        let label = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor)
        return label
    }()
    
    private var _iconView: IconDrawingView?
    
    var iconView: IconDrawingView {
        if _iconView != nil {
            return _iconView!
        } else {
            _iconView = KeyboardViewItem.iconDrawingView(keyType: key.type)
            return _iconView!
        }
    }
    
    
    init(frame: CGRect = CGRect.zero, key: Key? = nil) {
        self.key = key
        super.init(frame: frame)
        backgroundColor = UIColor.keyboardViewItemBackgroundColor
        clipsToBounds = true
        layer.cornerRadius = 6
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
        for v in subviews { v.removeFromSuperview()}
        layer.borderWidth = 0
        if key.withIcon {
            _iconView = nil
            addSubview(iconView)
        } else {
            addSubview(inscriptLabel)
            if key.type == .space {
                inscriptLabel.text = nil
                inscriptLabel.backgroundColor = UIColor.spaceColor
            } else {
                inscriptLabel.text = (GloabalKeyboardShiftState.isUppercase ? key.uppercaseKeyCap : key.lowercaseKeyCap) ?? "\(key.hashValue)"
                inscriptLabel.backgroundColor = UIColor.clear
            }
        }
        if key.type == .modeChange {
            inscriptLabel.font = KeyboardAppearanceScheme.keyboardViewItemInscriptFontSmall
            inscriptLabel.textColor = UIColor.globalDrawingColor
        } else {
            inscriptLabel.font = KeyboardAppearanceScheme.keyboardViewItemInscriptFont
            inscriptLabel.textColor = UIColor.keyboardViewItemInscriptColor
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(KeyboardViewItem.handleShiftStateChangedNotification(_:)),
                                                   name: Notification.Name("ShiftStateChanged"),
                                                   object: nil)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func handleShiftStateChangedNotification(_ notification: Notification) {
        if key.withIcon == false {
            inscriptLabel.text = (GloabalKeyboardShiftState.isUppercase ? key.uppercaseKeyCap : key.lowercaseKeyCap) ?? "\(key.hashValue)"
        }
        if key.type == .shift {
            switch GloabalKeyboardShiftState {
            case .enabled:
                UIView.animate(withDuration: 0.1) {
                    self.iconView.color = UIColor.shiftIconHighlightDrawingColor
                    self.layer.borderWidth = 0
                }
            case .disabled:
                UIView.animate(withDuration: 0.1) {
                    self.iconView.color = UIColor.shiftIconDrawingColor
                    self.layer.borderWidth = 0
                }
            case .locked:
                UIView.animate(withDuration: 0.1) {
                    self.iconView.color = UIColor.shiftIconHighlightDrawingColor
                    self.layer.borderWidth = 1
                    self.layer.borderColor = UIColor.shiftIconHighlightDrawingColor.cgColor
                }
            }
        }
        
    }
    
    var highlighted: Bool = false {didSet {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = self.highlighted ? UIColor.keyboardViewItemHighlightedBackgroundColor : UIColor.keyboardViewItemBackgroundColor
        }
        }}
}





























