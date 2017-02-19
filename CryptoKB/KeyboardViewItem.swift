//
//  KeyboardItemView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import ExtSwift

//final class KeyboardViewItem: UIView {
//    override var description: String { return super.description + itemID }
//    var itemID: String = ""
//    var inscriptLabel: UILabel = UILabel.keyboardLabel()
//    var iconImage: UIImage?
//    var inscript: String?
//    var normalBackgroundColor: UIColor = UIColor.keyboardViewItemBackgroundColor
//    var highlightedBackgroundColor: UIColor = UIColor.keyboardViewItemHighlightedBackgroundColor
//    
//
//    private var iconView: UIImageView = UIImageView()
//    
//    var shiftState: ShiftState = .disabled {
//        didSet {
//            handleShiftStateChanged()
//        }
//    }
//    
//    private func handleShiftStateChanged() {
//        if inscript != nil {
//            inscriptLabel.text = (shiftState.isUppercase ? inscript?.uppercased() : inscript?.lowercased()) ?? ""
//        }
//        if key.type == .shift {
//            switch shiftState {
//            case .enabled:
//                UIView.animate(withDuration: 0.1) {
//                    self.iconView.color = UIColor.shiftIconHighlightDrawingColor
//                    self.layer.borderWidth = 0
//                }
//            case .disabled:
//                UIView.animate(withDuration: 0.1) {
//                    self.iconView.color = UIColor.shiftIconDrawingColor
//                    self.layer.borderWidth = 0
//                }
//            case .locked:
//                UIView.animate(withDuration: 0.1) {
//                    self.iconView.color = UIColor.shiftIconHighlightDrawingColor
//                    self.layer.borderWidth = 1
//                    self.layer.borderColor = UIColor.shiftIconHighlightDrawingColor.cgColor
//                }
//            }
//        }
//    }
//    
//    override init(frame: CGRect = CGRect.zero) {
//        super.init(frame: frame)
//        clipsToBounds = true
//        layer.cornerRadius = 6
//        addSubview(iconView)
//        addSubview(inscriptLabel)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("Not implemented")
//    }
//    
//    private var boundSize: CGSize?
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if (bounds.width != 0 && bounds.height != 0) && (boundSize == nil || (bounds.size.equalTo(boundSize!) == false)) {
//            layoutItem()
//        }
//    }
//    
//    private func layoutItem() {
//        if iconImage != nil {
//            inscriptLabel.isHidden = true
//            iconView.isHidden = false
//            iconView.image = iconImage
//            iconView.frame = CGRect(x: 4, y: 4, width: bounds.width - 8, height: bounds.height - 8)
//            iconView.setNeedsDisplay()
//        } else {
//            inscriptLabel.isHidden = false
//            iconView.isHidden = true
//            inscriptLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
//        }
//    }
//    
//    var highlighted: Bool = false {
//        didSet {
//            UIView.animate(withDuration: 0.1) {
//                self.backgroundColor = self.highlighted
//                    ? self.normalBackgroundColor
//                    : self.highlightedBackgroundColor
//            }
//        }
//    }
//    
//}



//public struct KeyboardViewItemConfig: Hashable, CustomStringConvertible {
//    private static var counter = sequence(first: 0) { $0 + 1 }
//    public let hashValue: Int = KeyboardViewItemConfig.counter.next()!
//    public var description: String { return "\(self.hashValue)"}
//    
//    enum KeyType: UInt {
//        case shift
//        case backspace
//        case modeChange
//        case keyboardChange
//        case space
//        case `return`
//        case settings
//        case alphabet
//        case number
//        case symbol
//        case punctuation
//    }
//    
//    static let highlightableKeyTypes:[KeyType] = [.alphabet, .number, .symbol, .punctuation, .space]
//    static let iconKeyType:[KeyType] = [.shift, .backspace, .keyboardChange, .settings, .return]
//    
//    let type: KeyType
//    let meaning: String?
//    let inscript: String?
//    let toMode: Int?
//    
//    var uppercaseKeyCap: String? {return self.inscript?.uppercased()}
//    var lowercaseKeyCap: String? {return self.inscript?.lowercased()}
//    var uppercaseOutput: String? {return self.meaning?.uppercased()}
//    var lowercaseOutput: String? {return self.meaning?.lowercased()}
//    
//    var isAlphabet: Bool {return type == .alphabet}
//    var isHighlightable: Bool { return Key.highlightableKeyTypes.contains(type) }
//    
//    var withIcon: Bool { return Key.iconKeyType.contains(type) }
//    var hasOutput: Bool { return meaning != nil }
//    
//    
//    init(type: KeyType, meaning: String? = nil,  inscript: String? = nil, mode: Int? = nil) {
//        self.type = type
//        self.meaning = meaning
//        self.inscript = inscript ?? meaning
//        self.toMode = mode
//    }
//    
//    func outputForCase(_ uppercase: Bool) -> String {
//        return uppercase ? (self.uppercaseOutput ?? self.lowercaseOutput ?? "")
//            : (self.lowercaseOutput ?? self.uppercaseOutput ?? "")
//    }
//    
//    func keyCapForCase(_ uppercase: Bool) -> String {
//        return uppercase ? (self.uppercaseKeyCap ?? self.lowercaseKeyCap ?? "")
//            : (self.lowercaseKeyCap ?? self.uppercaseKeyCap ?? "")
//    }
//    
//    public static func == (lhs: KeyboardViewItemConfig, rhs: KeyboardViewItemConfig) -> Bool { return lhs.hashValue == rhs.hashValue }
//}


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
    
    private lazy var inscriptLabel: UILabel = {
        let label = UILabel.keyboardLabel(font: KeyboardAppearanceScheme.keyboardViewItemInscriptFont, textColor: UIColor.keyboardViewItemInscriptColor)
        return label
    }()
    
    private var _iconView: IconDrawingView?
    
    private var iconView: IconDrawingView {
        if _iconView != nil {
            return _iconView!
        } else {
            _iconView = KeyboardViewItem.iconDrawingView(keyType: key.type)
            return _iconView!
        }
    }
    
    var shiftState: ShiftState = .disabled {
        didSet {
            self.handleShiftStateChanged()
        }
    }
    
    init(frame: CGRect = CGRect.zero, key: Key? = nil) {
        self.key = key
        super.init(frame: frame)
        backgroundColor = UIColor.keyboardViewItemBackgroundColor
        clipsToBounds = true
        layer.cornerRadius = 6
        if key != nil { installKey()}
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
                inscriptLabel.text = (shiftState.isUppercase ? key.uppercaseKeyCap : key.lowercaseKeyCap) ?? "\(key.hashValue)"
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
    
    private func handleShiftStateChanged() {
        if key.withIcon == false {
            inscriptLabel.text = (shiftState.isUppercase ? key.uppercaseKeyCap : key.lowercaseKeyCap) ?? "\(key.hashValue)"
        }
        if key.type == .shift {
            switch shiftState {
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





























