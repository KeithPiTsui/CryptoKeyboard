//
//  NumericPadView.swift
//  CryptoKeyboard
//
//  Created by Pi on 13/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit




protocol NumericKeyboardDelegate: class {
    func nKeyboardViewItem(_ item: KeyboardViewItem, receivedEvent event: UIControlEvents, inKeyboard keyboard: NumericKeyboard)
}

class NumericKeyboard: UIView {
    /// a delegate to recieve keyboard event, like which key is pressed
    weak var delegate: NumericKeyboardDelegate?
    
    /// keyboard view data model, contains every item's information
    let keyboard: Keyboard = Keyboard.numericKeyboard
    
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
    
    init(frame: CGRect = CGRect.zero, withDelegate delegate: NumericKeyboardDelegate? = nil) {
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
        let keyboardViewItem = itemPool.popLast() ?? KeyboardViewItem()
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
        let itemWidth = frame.width / 3
        let itemHeight = frame.height / 4
        for row in 0...3 {
            for column in 0...2 {
                let x = CGFloat(column) * itemWidth
                let y = CGFloat(row) * itemHeight
                subviews[row*3+column].frame = CGRect(x,y,itemWidth,itemHeight)
                if row == 3 && column == 1 { // last element
                    var frame = subviews[row*3+column].frame
                    subviews[row*3+column-1].frame = frame
                    frame.origin.x += itemWidth
                    subviews[row*3+column].frame = frame
                    return
                }
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
        delegate.nKeyboardViewItem(control, receivedEvent: controlEvent, inKeyboard: self)
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
