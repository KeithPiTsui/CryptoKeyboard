//
//  AlphabetKeyboard.swift
//  CryptoKeyboard
//
//  Created by Pi on 14/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol AlphabetKeyboardDelegate: class {
    func keyboardViewItem(_ item: KeyboardViewItem, receivedEvent event: UIControlEvents, inKeyboard keyboard: AlphabetKeyboard)
}

class AlphabetKeyboard: UIView {
    /// a delegate to recieve keyboard event, like which key is pressed
    weak var delegate: AlphabetKeyboardDelegate?
    
    /// keyboard view data model, contains every item's information
    let keyboard: Keyboard = Keyboard.alphabetKeyboard
    
    /// a array to store reuse keyboard view item
    var itemPool: [KeyboardViewItem] = []
    
    /// to record which page it is now, when page change, re-organize keyboard
    ///
    /// value must be correspoding to data model keyboard
    var keyboardPage: Int = 0 {
        didSet {
            assembleKeyboardItems()
            layoutKeyboard()
        }
    }
    
    /// To record bound change
    private var boundSize: CGSize?
    
    var touchToView: [UITouch:UIView] = [:]
    
    init(frame: CGRect = CGRect.zero, withDelegate delegate: AlphabetKeyboardDelegate? = nil) {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (bounds.width != 0 && bounds.height != 0)
            && (boundSize == nil || (bounds.size.equalTo(boundSize!) == false)) {
            boundSize = bounds.size
            layoutKeyboard()
        }
    }
    
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
        
        return keyboardViewItem
    }
    
    private func positionKeyboardItems() {
        switch keyboardPage {
        case 0:
            positionKeyboardItemsPageZero()
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
    }
    
    
    // MARK: -
    // MARK: Touch Detection
    
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        return (isHidden || alpha == 0 || !isUserInteractionEnabled || !bounds.contains(point)) ? nil : self
    }
    
    private func handleControl(_ view: UIView?, controlEvent: UIControlEvents) {
        guard let control = view as? KeyboardViewItem, let delegate = delegate else { return }
        delegate.keyboardViewItem(control, receivedEvent: controlEvent, inKeyboard: self)
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
