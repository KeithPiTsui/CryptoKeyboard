//
//  TopBarView+Touch.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

extension TopBarView {
    // MARK: -
    // MARK: Touch Detection
    
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        return (isHidden || alpha == 0 || !isUserInteractionEnabled || !bounds.contains(point)) ? nil : self
    }
    
    private func handleControl(_ view: UIView?, controlEvent: UIControlEvents) {
        guard let label = view as? UILabel, let delegate = delegate else { return }
        delegate.topBarLabel(label, receivedEvent: controlEvent, inTopBar: self)
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
