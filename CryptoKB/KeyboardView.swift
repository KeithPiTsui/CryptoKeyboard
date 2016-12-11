//
//  KeyboardView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class KeyboardView: UIView {

    let keyboard: Keyboard = Keyboard.defaultKeyboard
    
    
    var keyboardPage: Int = 0 {
        didSet {
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.keyboardViewBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }
    
    func layoutKeyboard () {
        guard let superview = superview else { return }
        print(superview.frame)
    }
    
    private func changeKeyboardPage () {
        
    }
    
    private func assembleKeyboardItems () {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        for row in keyboard.keys[keyboardPage] {
            for key in row.flatMap({$0}) {
                
            }
        }
    }
    
    private func positionKeyboardItems () {
        
    }
    
    
}






























