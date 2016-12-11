//
//  KeyboardView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate: class {
    
}

class KeyboardView: UIView {

    weak var delegate: KeyboardViewDelegate?
    
    lazy var item: KeyboardViewItem = KeyboardViewItem(key: self.keyboard.keys[0][0][0]!)
    lazy var item2: KeyboardViewItem = KeyboardViewItem(key: self.keyboard.keys[0][0][1]!)
    let keyboard: Keyboard = Keyboard.defaultKeyboard
    
    var itemPool: [KeyboardViewItem] = []
    
    var keyboardPage: Int = 0 {
        didSet {
            assembleKeyboardItems()
            positionKeyboardItems()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.keyboardViewBackgroundColor
        assembleKeyboardItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }
    
    override func layoutSubviews() {
        layoutKeyboard()
        super.layoutSubviews()
    }
    
    func layoutKeyboard () {
        guard let superview = superview else { return }
        print(superview.frame)
        frame = superview.frame
        positionKeyboardItems()
    }
    
    private func assembleKeyboardItems () {
    
        for view in subviews {
            view.removeFromSuperview()
            if view is KeyboardViewItem {
                itemPool.append(view as! KeyboardViewItem)
            }
        }
//        addSubview(item)
//        addSubview(item2)
        
        for row in keyboard.keys[keyboardPage] {
            for key in row.flatMap({$0}) {
                let item = dequeueItem()
                item.key = key
                addSubview(item)
            }
        }
    }
    
    private func dequeueItem() -> KeyboardViewItem {
        guard itemPool.isEmpty else { return itemPool.removeLast() }
        return KeyboardViewItem()
    }
    
    
    private func positionKeyboardItems () {
        
//        item.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        item2.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
        
        // 9 items per line
        for (idx, item) in subviews.enumerated() {
            let lineNum = idx / 9
            let columnNum = idx % 9
            let x = 20 * columnNum
            let y = 20 * lineNum
            item.frame = CGRect(x: x, y: y, width: 20, height: 20)
            print(item.frame)
        }
        
    }
}






























