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

class KeyboardView: UIView {
    /// a delegate to recieve keyboard event, like which key is pressed
    weak var delegate: KeyboardViewDelegate?
    var listeners: NSMutableArray = NSMutableArray()
    
    /// to record which page it is now, when page change, re-organize keyboard
    ///
    /// value must be correspoding to data model keyboard
    var keyboardPage: Int = 0
    
    var keyboardDiagram: Diagram = Keyboard.defaultKeyboardDiagram
    
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
            self.subviews.forEach({ (subview) in
                subview.removeFromSuperview()
            })
            self.layout(keyboardDiagram, in: bounds)
            
        }
    }
}

internal final class KeyboardViewDefaultDelegate: KeyboardViewDelegate {
    
    let ob: Observer<KeyboardViewItem, NoError>
    
    init(ob: Observer<KeyboardViewItem, NoError>) {
        self.ob = ob
    }
    
    func keyboardViewItem(_ item: KeyboardViewItem,
                          receivedEvent event: UIControlEvents,
                          inKeyboard keyboard: KeyboardView){
        ob.send(value: item)
    }
}

extension Reactive where Base: KeyboardView {
    var continuousKeyItems: Signal<KeyboardViewItem, NoError> {
        return Signal { observer in
            
            let delegate = KeyboardViewDefaultDelegate(ob: observer)
            base.listeners.add(delegate)

            
            let disposable = lifetime.ended.observeCompleted(observer.sendCompleted)
            
            return ActionDisposable { [weak base = self.base] in
                disposable?.dispose()
                base?.listeners.remove(delegate)

            }
        }
    }
}




























