//
//  KeyboardView.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

struct KeyboardViewItemConfig {
    let icon: UIImage?
    let iconColor: UIColor?
    let inscript: String = ""
    let inscriptFont: UIFont = UIFont.systemFont(ofSize: 12)
    let inscriptTextColor: UIColor = UIColor.clear
    let backgroundColor: UIColor = UIColor.clear
}

final class KeyboardView: UIView {

    var keyboardDiagram: Diagram<Key> = Keyboard.defaultKeyboardDiagram {
        didSet {
            boundSize = nil
            self.setNeedsLayout()
        }
    }
    
    var keyboardMode = 0 {
        didSet {
            switch keyboardMode {
            case 0:
                keyboardDiagram = Keyboard.defaultKeyboardDiagram
            case 1:
                keyboardDiagram = Keyboard.numberPunctuationKeyboardDiagram
            case 2:
                keyboardDiagram = Keyboard.symbolKeyboardDiagram
            default:
                fatalError("No corresponding keyboard for mode \(keyboardMode)")
            }
        }
    }
    
    var shiftState: ShiftState = .disabled {
        didSet {
            self.subviews.forEach{
                guard let i = $0 as? KeyboardViewItem else { return }
                i.shiftState = self.shiftState
            }
        }
    }
    
    /// To record bound change
    private var boundSize: CGSize?
    
    fileprivate var touchToView: [UITouch:UIView] = [:]
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.keyboardViewBackgroundColor
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        isOpaque = false
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width != 0 && bounds.height != 0 else { return }
        guard boundSize == nil || bounds.size.equalTo(boundSize!) == false else { return }
        
        boundSize = bounds.size
        subviews.forEach{ $0.removeFromSuperview() }
        layout(keyboardDiagram, in: bounds)

    }
    
    fileprivate var eventHanlders = [UInt: [KeyboardViewEventHanlder]]()
    
    func addEventHandler(_ handler: KeyboardViewEventHanlder, for controlEvents: UIControlEvents) {
        if eventHanlders[controlEvents.rawValue] == nil {
            eventHanlders[controlEvents.rawValue] = [handler]
        } else {
            eventHanlders[controlEvents.rawValue]!.append(handler)
        }
    }
    
    func removeEventHandler(_ handler: KeyboardViewEventHanlder, for controlEvents: UIControlEvents) {
        let idx = eventHanlders[controlEvents.rawValue]?.index{ $0 === handler }
        if idx != nil {
            eventHanlders[controlEvents.rawValue]?.remove(at: idx!)
        }
    }
    
}

protocol KeyboardViewEventHanlder: class {
    func event(_ e: UIControlEvents, on item: KeyboardViewItem, at Keyboard: KeyboardView)
}

final class ObserverWrapper {
    let observer: Observer<KeyboardViewItem, NoError>
    init(ob: Observer<KeyboardViewItem, NoError>) { observer = ob }
}

extension ObserverWrapper: KeyboardViewEventHanlder {
    func event(_ e: UIControlEvents, on item: KeyboardViewItem, at Keyboard: KeyboardView) { observer.send(value: item)}
}


extension Reactive where Base: KeyboardView {
    func controlEvents(_ event: UIControlEvents) -> Signal<KeyboardViewItem, NoError> {
        return Signal { observer in
            let obWrapper = ObserverWrapper(ob: observer)
            base.addEventHandler(obWrapper, for: event)
            let disposable = lifetime.ended.observeCompleted(observer.sendCompleted)
            return ActionDisposable { [weak base = self.base] in
                disposable?.dispose()
                base?.removeEventHandler(obWrapper, for: event)
            }
        }
    }
    
    var continuousKeyPressed: Signal<KeyboardViewItem, NoError> { return controlEvents(.touchUpInside) }
    
    var continuousKeyDoubleClicked: Signal<KeyboardViewItem, NoError> { return controlEvents(.touchDownRepeat) }
}


extension KeyboardView {
    func layout(_ primitive: Primitive<Key>, in frame: CGRect) {
        if case let .element(k) = primitive {
            let kv = KeyboardViewItem(frame: frame, key: k)
            kv.shiftState = self.shiftState
            self.addSubview(kv)
        }
    }
    
    func layout(_ diagram: Diagram<Key>, in bounds: CGRect) {
        switch diagram {
        case let .primitive(size, primitive):
            let bounds = size.fit(into: bounds, alignment: .center)
            layout(primitive, in: bounds)
            
        case .align(let alignment, let diagram):
            let bounds = diagram.size.fit(into: bounds, alignment: alignment)
            layout(diagram, in: bounds)
            
        case let .beside(l, _, r):
            let (lBounds, rBounds) = bounds.splitThree(firstFraction: l.size.width / diagram.size.width,
                                                       lastFraction: r.size.width / diagram.size.width,
                                                       isHorizontal: true)
            layout(l, in: lBounds)
            layout(r, in: rBounds)
            
        case .below(let top, _, let bottom):
            let (tBounds, bBounds) = bounds.splitThree(firstFraction: top.size.height / diagram.size.height,
                                                       lastFraction: bottom.size.height / diagram.size.height,
                                                       isHorizontal: false)
            layout(top, in: tBounds)
            layout(bottom, in: bBounds)
        }
    }
}

// MARK: -
// MARK: Touch Detection

extension KeyboardView {
    private func handleControl(_ view: UIView?, controlEvent: UIControlEvents) {
        guard let control = view as? KeyboardViewItem else { return }
        guard let handlers = eventHanlders[controlEvent.rawValue] else { return }
        handlers.forEach { $0.event(controlEvent, on: control, at: self) }
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
        guard rect.contains(point) == false else { return 0 }
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
    
    private func ownView(_ newTouch: UITouch, viewToOwn: UIView?) -> Bool {
        defer { touchToView[newTouch] = viewToOwn}
        guard viewToOwn != nil else { return false }
        var foundView = false
        for (touch, view) in touchToView {
            if viewToOwn == view {
                if touch != newTouch {
                    touchToView[touch] = nil
                    foundView = true
                }
                break
            }
        }
        return foundView
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        return (isHidden || alpha == 0 || !isUserInteractionEnabled || !bounds.contains(point)) ? nil : self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let view = findNearestView(touch.location(in: self))
            guard ownView(touch, viewToOwn: view) == false else { return }
            handleControl(view, controlEvent: .touchDown)
            guard touch.tapCount > 1 else { return }
            handleControl(view, controlEvent: .touchDownRepeat)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let oldView = touchToView[touch]
            let newView = findNearestView(touch.location(in: self))
            guard oldView != newView else { handleControl(oldView, controlEvent: .touchDragInside); return }
            handleControl(oldView, controlEvent: .touchDragExit)
            ownView(touch, viewToOwn: newView)
                ? handleControl(newView, controlEvent: .touchDragInside)
                : handleControl(newView, controlEvent: .touchDragEnter)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let view = touchToView[touch]
            bounds.contains(touch.location(in: self))
                ? handleControl(view, controlEvent: .touchUpInside)
                : handleControl(view, controlEvent: .touchCancel)
            touchToView[touch] = nil
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach{
            handleControl(touchToView[$0], controlEvent: .touchCancel)
            touchToView[$0] = nil
        }
    }
}

























