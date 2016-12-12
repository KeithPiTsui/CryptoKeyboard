//
//  KeyboardLayoutHelper.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

extension KeyboardView {
    // MARK: -
    // MARK: Item Assembling and Layout
    
    /// resize and reposition every Keyboard item properly
    ///
    /// Don't call this function directly
    func layoutKeyboard () {
        positionKeyboardItems()
    }
    
    /// add all keyboard item of corresponding keyboard page to keyboard view as subviews
    ///
    /// Don't call this function directly
    func assembleKeyboardItems () {
        for view in subviews {
            view.removeFromSuperview()
            if let kbv = view as? KeyboardViewItem {
                itemPool.append(kbv)
            }
        }
        
        for row in keyboard.keys[keyboardPage] {
            for key in row.flatMap({$0}) {
                let item = dequeueItem(forKey: key)
                addSubview(item)
            }
        }
    }
    
    private func dequeueItem(forKey key: Key) -> KeyboardViewItem {
        var keyboardViewItem: KeyboardViewItem! = nil
        if itemPool.isEmpty {
            keyboardViewItem = KeyboardViewItem()
        } else {
            keyboardViewItem = itemPool.removeLast()
        }
        keyboardViewItem.key = key
        
        //bindKey(key: key, withKeyboardViewItem: keyboardViewItem)
        
        return keyboardViewItem
    }
    
    private func positionKeyboardItems() {
        switch keyboardPage {
        case 0:
            positionKeyboardItemsPageZero()
        case 1:
            positionKeyboardItemsPageOne()
        case 2:
            positionKeyboardItemsPageOne()
        default: break
        }
    }
    
    private func positionKeyboardItemsPageZero () {
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
                let x = LayoutConstraints.keyboardFirstRowLeadingGap
                subviews[i+28].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 1 {
                let iw = subviews[28+i-1].frame.width
                let x = subviews[28+i-1].frame.origin.x + subviews[28+i-1].frame.width + LayoutConstraints.keyboardRowGap
                subviews[i+28].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 2 {
                let x = subviews[28+i-1].frame.origin.x + subviews[28+i-1].frame.width + LayoutConstraints.keyboardRowGap
                subviews[i+28].frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            } else if i == 3 {
                let x = subviews[28+i-1].frame.origin.x + subviews[28+i-1].frame.width + LayoutConstraints.keyboardRowGap
                let iw = itemWidth * 4 + LayoutConstraints.keyboardRowGap * 3
                subviews[i+28].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 4 {
                let x = subviews[28+i-1].frame.origin.x + subviews[28+i-1].frame.width + LayoutConstraints.keyboardRowGap
                let iw = frame.width - LayoutConstraints.keyboardFirstRowLeadingGap - x
                subviews[i+28].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            }
        }
    }
    
    private func positionKeyboardItemsPageOne () {
        // First line
        let itemWidth = (frame.width - 2*LayoutConstraints.keyboardFirstRowLeadingGap - 9*LayoutConstraints.keyboardFirstRowItemGap) / 10
        let itemHeight = (frame.height - LayoutConstraints.keyboardRowTopGap - 3*LayoutConstraints.keyboardRowGap - LayoutConstraints.keyboardLastRowGap) / 4
        for i in 0...9 {
            let x = LayoutConstraints.keyboardFirstRowLeadingGap + CGFloat(i) * (itemWidth + LayoutConstraints.keyboardFirstRowItemGap)
            let y = LayoutConstraints.keyboardRowTopGap
            subviews[i].frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        }
        
        // Second line
        
        for i in 0...9 {
            let x = LayoutConstraints.keyboardFirstRowLeadingGap + CGFloat(i) * (itemWidth + LayoutConstraints.keyboardFirstRowItemGap)
            let y = LayoutConstraints.keyboardRowTopGap + itemHeight + LayoutConstraints.keyboardRowGap
            subviews[i+10].frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        }
        
        // Third line
        for i in 0...6 {
            let y = LayoutConstraints.keyboardRowTopGap + itemHeight*2 + LayoutConstraints.keyboardRowGap*2
            if i == 0 {
                let iw = itemWidth + LayoutConstraints.keyboardRowGap
                let x = LayoutConstraints.keyboardFirstRowLeadingGap + CGFloat(i) * (iw + LayoutConstraints.keyboardFirstRowItemGap)
                subviews[i+20].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 6 {
                let x = frame.width - LayoutConstraints.keyboardFirstRowLeadingGap - subviews[20].frame.width
                subviews[i+20].frame = CGRect(x: x, y: y, width: subviews[19].frame.width, height: itemHeight)
                
            } else if i == 1 {
                let x = subviews[20].frame.origin.x + subviews[20].frame.width + 3 * LayoutConstraints.keyboardRowGap
                let iw = (frame.width - subviews[20].frame.width * 2 - LayoutConstraints.keyboardRowGap * 10) / 5
                subviews[i+20].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else {
                let x = subviews[i+20-1].frame.origin.x + subviews[i+20-1].frame.width + LayoutConstraints.keyboardRowGap
                let iw = subviews[i+20-1].frame.width
                subviews[i+20].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            }
        }
        
        // Four line
        for i in 0...4 {
            let y = LayoutConstraints.keyboardRowTopGap + itemHeight*3 + LayoutConstraints.keyboardRowGap*3
            if i == 0 {
                let iw = itemWidth + LayoutConstraints.keyboardRowGap
                let x = LayoutConstraints.keyboardFirstRowLeadingGap
                subviews[i+27].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 1 {
                let iw = subviews[27+i-1].frame.width
                let x = subviews[27+i-1].frame.origin.x + subviews[27+i-1].frame.width + LayoutConstraints.keyboardRowGap
                subviews[i+27].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 2 {
                let x = subviews[27+i-1].frame.origin.x + subviews[27+i-1].frame.width + LayoutConstraints.keyboardRowGap
                subviews[i+27].frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            } else if i == 3 {
                let x = subviews[27+i-1].frame.origin.x + subviews[27+i-1].frame.width + LayoutConstraints.keyboardRowGap
                let iw = itemWidth * 4 + LayoutConstraints.keyboardRowGap * 3
                subviews[i+27].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            } else if i == 4 {
                let x = subviews[27+i-1].frame.origin.x + subviews[27+i-1].frame.width + LayoutConstraints.keyboardRowGap
                let iw = frame.width - LayoutConstraints.keyboardFirstRowLeadingGap - x
                subviews[i+27].frame = CGRect(x: x, y: y, width: iw, height: itemHeight)
            }
        }
        
    }
}
