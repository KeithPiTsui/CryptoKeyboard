//
//  KeyboardView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class KeyboardView: UIView {
    /// a delegate to recieve keyboard event, like which key is pressed
    weak var delegate: KeyboardViewDelegate?
    
    /// keyboard view data model, contains every item's information
    let keyboard: Keyboard = Keyboard.defaultKeyboard
    
    /// a array to store reuse keyboard view item
    var itemPool: [KeyboardViewItem] = []
    
    /// to record which page it is now, when page change, re-organize keyboard
    ///
    /// value must be correspoding to data model keyboard
    var keyboardPage: Int = 0 {
        didSet {
//            assembleKeyboardItems()
//            layoutKeyboard()
        }
    }
    
    
    
    /// To record bound change
    private var boundSize: CGSize?
    
    var touchToView: [UITouch:UIView] = [:]
    
    init(frame: CGRect = CGRect.zero, withDelegate delegate: KeyboardViewDelegate? = nil) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        backgroundColor = UIColor.keyboardViewBackgroundColor
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        isOpaque = false
        
//        assembleKeyboardItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (bounds.width != 0 && bounds.height != 0)
            && (boundSize == nil || (bounds.size.equalTo(boundSize!) == false)) {
            boundSize = bounds.size
//            layoutKeyboard()
            self.subviews.forEach({ (subview) in
                subview.removeFromSuperview()
            })
            let dia = generateKeyboardDiagram()
            self.layout(dia, in: bounds)
            
        }
    }
    
    private func generateKeyboardDiagram() -> Diagram {
        let a = Primitive.key(Key(type: .character, meaning: "A", inscript: "A", mode: 0))
        let b = Primitive.key(Key(type: .character, meaning: "B", inscript: "B", mode: 0))
        return Diagram.primitive(CGSize(width: 1, height: 1), a) ||| Diagram.primitive(CGSize(width: 1, height: 1), b)
    }
    
    private func generateKeyPrimitive(_ t: String) -> Primitive {
        return Primitive.key(Key(type: .character, meaning: t, inscript: t, mode: 0))
    }
}






























