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
    
    func layoutKeyboard () {
        guard let superview = superview else { return }
        //print(superview.frame)
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
//        for (idx, item) in subviews.enumerated() {
//            let lineNum = idx / 9
//            let columnNum = idx % 9
//            let x = 20 * columnNum
//            let y = 20 * lineNum
//            item.frame = CGRect(x: x, y: y, width: 20, height: 20)
//        }
        
        // First line
        let itemWidth = (frame.width - 2*LayoutConstraints.keyboardFirstRowLeadingGap - 9*LayoutConstraints.keyboardFirstRowItemGap) / 10
        let itemHeight = (frame.height - LayoutConstraints.keyboardRowTopGap - 3*LayoutConstraints.keyboardRowGap - LayoutConstraints.keyboardLastRowGap) / 4
        for i in 0...9 {
            let x = LayoutConstraints.keyboardFirstRowLeadingGap + CGFloat(i) * (itemWidth + LayoutConstraints.keyboardFirstRowItemGap)
            let y = LayoutConstraints.keyboardRowTopGap
            subviews[i].frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        }
        
        // Second line
        let secondRowLeadingGap = (frame.width - 9 * itemWidth - 8 * LayoutConstraints.keyboardFirstRowItemGap) / 2
        for i in 0...8 {
            let x = secondRowLeadingGap + CGFloat(i) * (itemWidth + LayoutConstraints.keyboardFirstRowItemGap)
            let y = LayoutConstraints.keyboardRowTopGap + itemHeight + LayoutConstraints.keyboardRowGap
            subviews[i+10].frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        }
        
        // Third line
        for i in 0...8 {
            let y = LayoutConstraints.keyboardRowTopGap + itemHeight*2 + LayoutConstraints.keyboardRowGap*2
            if i == 0 {
                let iw = itemWidth + LayoutConstraints.keyboardRowGap
                let x = LayoutConstraints.keyboardFirstRowLeadingGap + CGFloat(i) * (iw + LayoutConstraints.keyboardFirstRowItemGap)
                subviews[i+19].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 8 {
                let x = frame.width - LayoutConstraints.keyboardFirstRowLeadingGap - subviews[19].frame.width
                subviews[i+19].frame = CGRect(x: x, y: y, width: subviews[19].frame.width, height: itemHeight)
            } else {
                let x = subviews[i+19-9].frame.origin.x
                subviews[i+19].frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            }
        }
        
        // Four line
        for i in 0...4 {
            let y = LayoutConstraints.keyboardRowTopGap + itemHeight*3 + LayoutConstraints.keyboardRowGap*3
            if i == 0 {
                let iw = itemWidth + LayoutConstraints.keyboardRowGap
                let x = LayoutConstraints.keyboardFirstRowLeadingGap + CGFloat(i) * (iw + LayoutConstraints.keyboardFirstRowItemGap)
                subviews[i+28].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 1 {
                let iw = subviews[28].frame.width
                let x = subviews[20].frame.origin.x + subviews[20].frame.width - iw
                subviews[i+28].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 2 {
                let x = subviews[21].frame.origin.x
                subviews[i+28].frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            } else if i == 3 {
                let x = subviews[22].frame.origin.x
                let iw = subviews[25].frame.origin.x + subviews[25].frame.width - x
                subviews[i+28].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 4 {
                let x = subviews[26].frame.origin.x
                let iw = frame.width - LayoutConstraints.keyboardFirstRowLeadingGap - x
                subviews[i+28].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            }

        }
        
    }
}






























