//
//  KeyboardViewController+KeyboardViewDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

// MARK: -
// MARK: Keyboard View Delegate Extension
extension KeyboardViewController: KeyboardViewDelegate {
    
    func keyboardViewItem(_ item: KeyboardViewItem, receivedEvent event: UIControlEvents, inKeyboard keyboard: KeyboardView) {
        print("\(#function)")
        handlEvent(event, withKeyboardViewItem: item)
    }
    
    // MARK -
    // MARK - Touch Event Hanlder
    private func handlEvent(_ event: UIControlEvents, withKeyboardViewItem item: KeyboardViewItem) {
        guard let key = item.key else { return }
        
        switch key.type {
            case .keyboardChange:
                if event == .touchUpInside {
                    changeKeyboard(item)
                }
                
            case .backspace:
                if event == .touchDown {
                    pressBackspace(item)
                }
                if [.touchDragExit, .touchUpOutside, .touchCancel, .touchDragOutside].contains(event) {
                    pressBackspaceCancel(item)
                }
                
            case .shift:
                if event == .touchDown {
                    pressShiftDown(item)
                }
                if event == .touchUpInside {
                    pressShiftUpInside(item)
                }
                if event == .touchDownRepeat {
                    doubleTapShift(item)
                }
                
            case .modeChange:
                if event == .touchDown {
                    nextKeyboardPage(item)
                }
            case .settings:
                if event == .touchUpInside {
                    pressSettings(item)
                }
            default:
                break
        }
        
        if key.isCharacter {
            if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
                if [.touchDown, .touchDragInside, .touchDragEnter].contains(event) {
                    showPopup(item)
                }
                if [.touchUpInside, .touchUpOutside, .touchDragOutside].contains(event) {
                    hidePopupDelay(item)
                }
            }
        }
        
        
        if key.hasOutput && event == .touchUpInside {
            pressAnOutputItem(item)
        }
        
        if key.type != .shift && key.type != .modeChange {
            if [.touchDown, .touchDragInside, .touchDragEnter].contains(event) {
                highlightItem(item)
            }
            if [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit, .touchCancel].contains(event) {
                unhighlightItem(item)
            }
        }
        
        if event == .touchDown {
            playClickSound(item)
        }
    }
    
    func changeKeyboard(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
        advanceToNextInputMode()
    }
    func pressBackspace(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressBackspaceCancel(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressShiftDown(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressShiftUpInside(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func doubleTapShift(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func nextKeyboardPage(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
        guard let page = sender.key.toMode else {return}
        keyboardView.keyboardPage = page
    }
    func pressSettings(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func pressAnOutputItem(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func highlightItem(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func unhighlightItem(_ sender: KeyboardViewItem) {
        print("\(#function):\(#line)")
    }
    func playClickSound(_ sender: KeyboardViewItem){
        print("\(#function):\(#line)")
    }
    func showPopup(_ sender: KeyboardViewItem) {
        
    }
    func hidePopupDelay(_ sender: KeyboardViewItem){
        
    }
}
