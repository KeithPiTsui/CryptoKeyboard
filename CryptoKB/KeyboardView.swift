//
//  KeyboardView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class KeyboardView: UIView {
    weak var delegate: KeyboardViewDelegate?
    let keyboard: Keyboard = Keyboard.defaultKeyboard
    var itemPool: [KeyboardViewItem] = []
    var keyboardPage: Int = 2 {
        didSet {
            assembleKeyboardItems()
            positionKeyboardItems()
        }
    }
    var boundSize: CGSize?
    
    init(frame: CGRect = CGRect.zero, withDelegate delegate: KeyboardViewDelegate? = nil) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        backgroundColor = UIColor.keyboardViewBackgroundColor
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        isOpaque = false
        assembleKeyboardItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }
    
    // MARK: -
    // MARK: Item Assembling and Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (bounds.width != 0 && bounds.height != 0) && (boundSize == nil || (bounds.size.equalTo(boundSize!) == false)) {
            boundSize = bounds.size
            self.layoutKeyboard()
        }
    }
    
    func layoutKeyboard () {
        positionKeyboardItems()
    }
    
    private func assembleKeyboardItems () {
        for view in subviews {
            view.removeFromSuperview()
            if let kbv = view as? KeyboardViewItem {
                kbv.removeTarget(nil, action: nil, for: .allEvents)
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
        
        bindKey(key: key, withKeyboardViewItem: keyboardViewItem)
        
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
    
    
    // MARK -
    // MARK - Touch Event Hanlder
    
    private func bindKey(key: Key, withKeyboardViewItem item: KeyboardViewItem) {
        guard let delegate = delegate else {return}
        
        item.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
        
        switch key.type {
        case Key.KeyType.keyboardChange:
            item.addTarget(delegate, action: Selector(("changeKeyboard:")), for: .touchUpInside)
            
        case Key.KeyType.backspace:
            let cancelEvents: UIControlEvents = [.touchDragExit, .touchUpOutside, .touchCancel, .touchDragOutside]
            item.addTarget(delegate, action: Selector(("pressBackspace:")), for: .touchDown)
            item.addTarget(delegate, action: Selector(("pressBackspaceCancel:")), for: cancelEvents)
            
        case Key.KeyType.shift:
            item.addTarget(delegate, action: Selector(("pressShiftDown:")), for: .touchDown)
            item.addTarget(delegate, action: Selector(("pressShiftUpInside:")), for: .touchUpInside)
            item.addTarget(delegate, action: Selector(("doubleTapShift:")), for: .touchDownRepeat)
            
        case Key.KeyType.modeChange:
            item.addTarget(delegate, action: Selector(("nextKeyboardPage:")), for: .touchDown)
            
        case Key.KeyType.settings:
            item.addTarget(delegate, action: Selector(("pressSettings:")), for: .touchUpInside)
            
        default:
            break
        }
        
//        if key.isCharacter {
//            if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
//                item.addTarget(delegate, action: #selector(KeyboardViewController.showPopup(_:)), for: [.touchDown, .touchDragInside, .touchDragEnter])
//                //item.addTarget(keyView, action: Selector(("hidePopup")), for: [.touchDragExit, .touchCancel])
//                item.addTarget(delegate, action: #selector(KeyboardViewController.hidePopupDelay(_:)), for: [.touchUpInside, .touchUpOutside, .touchDragOutside])
//            }
//        }
        
        if key.hasOutput {
            item.addTarget(delegate, action: Selector(("pressAnOutputItem:")), for: .touchUpInside)
        }
        
        if key.type != Key.KeyType.shift && key.type != Key.KeyType.modeChange {
            item.addTarget(delegate, action: Selector(("highlightItem:")), for: [.touchDown, .touchDragInside, .touchDragEnter])
            item.addTarget(delegate, action: Selector(("unhighlightItem:")), for: [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit, .touchCancel])
        }
        
        item.addTarget(delegate, action: Selector(("playClickSound:")), for: .touchDown)
    }
    
    
    // MARK: -
    // MARK: Touch Detection
    
    private var touchToView: [UITouch:UIView] = [:]

    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        return (isHidden || alpha == 0 || !isUserInteractionEnabled || !bounds.contains(point)) ? nil : self
    }
    
    private func handleControl(_ view: UIView?, controlEvent: UIControlEvents) {
        guard let control = view as? UIControl else { return }
        for target in control.allTargets {
            guard let actions = control.actions(forTarget: target, forControlEvent: controlEvent) else { continue }
            for action in actions {
                control.sendAction(Selector(action), to: target, for: nil)
            }
        }
    }
    
    private func findNearestView(_ position: CGPoint) -> UIView? {
        guard self.bounds.contains(position) && !subviews.isEmpty else { return nil}
        var closest: (UIView, CGFloat) = (self, CGFloat.greatestFiniteMagnitude)
        for view in subviews {
            guard !view.isHidden else { continue }
            view.alpha = 1
            let distance = distanceBetween(view.frame, point: position)
            if distance < closest.1 {
                closest = (view, distance)
            }
        }
        return closest.0
    }
    
    private func distanceBetween(_ rect: CGRect, point: CGPoint) -> CGFloat {
        if rect.contains(point) {return 0 }
        
        var closest = rect.origin
        
        if (rect.origin.x + rect.size.width < point.x) {
            closest.x += rect.size.width
        } else if (point.x > rect.origin.x) {
            closest.x = point.x
        }
        if (rect.origin.y + rect.size.height < point.y) {
            closest.y += rect.size.height
        } else if (point.y > rect.origin.y) {
            closest.y = point.y
        }
        
        let a = pow(Double(closest.y - point.y), 2)
        let b = pow(Double(closest.x - point.x), 2)
        return CGFloat(sqrt(a + b));
    }
    
    /// reset tracked views without cancelling current touch
    private func resetTrackedViews() {
        for view in touchToView.values {
            handleControl(view, controlEvent: .touchCancel)
        }
        self.touchToView.removeAll(keepingCapacity: true)
    }
    
    private func ownView(_ newTouch: UITouch, viewToOwn: UIView?) -> Bool {
        var foundView = false
        if viewToOwn != nil {
            for (touch, view) in touchToView {
                if viewToOwn == view {
                    if touch != newTouch {
                        touchToView[touch] = nil
                        foundView = true
                    }
                    break
                }
            }
        }
        touchToView[newTouch] = viewToOwn
        return foundView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            let view = findNearestView(position)
            let viewChangedOwnership = ownView(touch, viewToOwn: view)
            if !viewChangedOwnership {
                handleControl(view, controlEvent: .touchDown)
                if touch.tapCount > 1 {
                    handleControl(view, controlEvent: .touchDownRepeat)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            let oldView = touchToView[touch]
            let newView = findNearestView(position)
            if oldView != newView {
                handleControl(oldView, controlEvent: .touchDragExit)
                let viewChangedOwnership = ownView(touch, viewToOwn: newView)
                if !viewChangedOwnership {
                    handleControl(newView, controlEvent: .touchDragEnter)
                } else {
                    handleControl(newView, controlEvent: .touchDragInside)
                }
            } else {
                handleControl(oldView, controlEvent: .touchDragInside)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = touchToView[touch]
            let touchPosition = touch.location(in: self)
            if bounds.contains(touchPosition) {
                handleControl(view, controlEvent: .touchUpInside)
            } else {
                handleControl(view, controlEvent: .touchCancel)
            }
            touchToView[touch] = nil
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = touchToView[touch]
            handleControl(view, controlEvent: .touchCancel)
            touchToView[touch] = nil
        }
    }
    
}






























