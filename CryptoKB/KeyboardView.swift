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

protocol KeyboardViewEventHanlder: class {
    func event(_ e: UIControlEvents, on item: KeyboardViewItem, at Keyboard: KeyboardView)
}


final class KeyboardView: UIView {
    /// a delegate to recieve keyboard event, like which key is pressed
    weak var delegate: KeyboardViewDelegate?
    
    var keyboardDiagram: Diagram = Keyboard.symbolKeyboardDiagram { didSet {self.setNeedsLayout()}}
    
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
    
    var touchToView: [UITouch:UIView] = [:]
    
    init(frame: CGRect = CGRect.zero, withDelegate delegate: KeyboardViewDelegate? = nil) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        backgroundColor = UIColor.keyboardViewBackgroundColor
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        isOpaque = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (bounds.width != 0 && bounds.height != 0)
            && (boundSize == nil || (bounds.size.equalTo(boundSize!) == false)) {
            boundSize = bounds.size
            subviews.forEach{ $0.removeFromSuperview() }
            layout(keyboardDiagram, in: bounds)
        }
    }
    
    var eventHanlders = [UInt: [KeyboardViewEventHanlder]]()
    
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

final class ObserverWrapper {
    let observer: Observer<KeyboardViewItem, NoError>
    init(ob: Observer<KeyboardViewItem, NoError>) {
        observer = ob
    }
}

extension ObserverWrapper: KeyboardViewEventHanlder {
    func event(_ e: UIControlEvents, on item: KeyboardViewItem, at Keyboard: KeyboardView) {
        observer.send(value: item)
    }
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
    
    var continuousKeyPressed: Signal<KeyboardViewItem, NoError> {
        return controlEvents(.touchUpInside)
    }
    
    var continuousKeyDoubleClicked: Signal<KeyboardViewItem, NoError> {
        return controlEvents(.touchDownRepeat)
    }
}



























