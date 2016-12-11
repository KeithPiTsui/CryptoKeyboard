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
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        isOpaque = false
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
    
    
    var touchToView: [UITouch:UIView] = [:]
    
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        return (isHidden || alpha == 0 || !isUserInteractionEnabled || !bounds.contains(point)) ? nil : self
    }
    
    func handleControl(_ view: UIView?, controlEvent: UIControlEvents) {
        guard let control = view as? UIControl else { return }
        for target in control.allTargets {
            guard let actions = control.actions(forTarget: target, forControlEvent: controlEvent) else { continue }
            for action in actions {
                control.sendAction(Selector(action), to: target, for: nil)
            }
        }
    }
    
    // TODO: there's a bit of "stickiness" to Apple's implementation
    func findNearestView(_ position: CGPoint) -> UIView? {
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
    
    func distanceBetween(_ rect: CGRect, point: CGPoint) -> CGFloat {
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
    func resetTrackedViews() {
        for view in touchToView.values {
            handleControl(view, controlEvent: .touchCancel)
        }
        self.touchToView.removeAll(keepingCapacity: true)
    }
    
    func ownView(_ newTouch: UITouch, viewToOwn: UIView?) -> Bool {
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
                    // two events, I think this is the correct behavior but I have not tested with an actual UIControl
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






























