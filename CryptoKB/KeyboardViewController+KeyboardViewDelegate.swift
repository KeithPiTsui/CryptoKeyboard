//
//  KeyboardViewController+KeyboardViewDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit
import AudioToolbox

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
                if [.touchDragExit,.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside].contains(event) {
                    pressBackspaceCancel(item)
                }
                
            case .shift:
                if event == .touchDown {
                    pressShiftDown(item)
                }
                if event == .touchDownRepeat {
                    doubleTapShift(item)
                }
                
            case .modeChange:
                if event == .touchUpInside {
                    nextKeyboardPage(item)
                }
            case .settings:
                if event == .touchUpInside {
                    pressSettings(item)
                }
            default:
                break
        }
        
        if key.isHighlightable {
            if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
                if [.touchDown, .touchDragInside, .touchDragEnter].contains(event) {
                    highlightItem(item)
                }
                if [.touchUpInside, .touchUpOutside, .touchDragOutside].contains(event) {
                    unhighlightItem(item)
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
    
    private func changeKeyboard(_ sender: KeyboardViewItem) {
        print("\(#function)")
        advanceToNextInputMode()
    }
    
    private func pressBackspace(_ sender: KeyboardViewItem) {
        print("\(#function)")
        textDocumentProxy.deleteBackward()
        textInterpreter.removeLastReceiveCharacter()
        setCapsIfNeeded()
        // trigger for subsequent deletes
        backspaceDelayTimer = Timer.scheduledTimer(timeInterval: backspaceDelay - backspaceRepeat,
                                                   target: self,
                                                   selector: #selector(KeyboardViewController.backspaceDelayCallback),
                                                   userInfo: nil,
                                                   repeats: false)
    }
    
    func cancelBackspaceTimers() {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        backspaceDelayTimer = nil
        backspaceRepeatTimer = nil
    }
    
//    func backspaceDown(_ sender: KeyboardViewItem) {
//        cancelBackspaceTimers()
//        textDocumentProxy.deleteBackward()
//        setCapsIfNeeded()
//        
//        
//    }
    
    func pressBackspaceCancel(_ sender: KeyboardViewItem) {
        cancelBackspaceTimers()
    }
    
    func backspaceDelayCallback() {
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = Timer.scheduledTimer(timeInterval: backspaceRepeat,
                                                         target: self,
                                                         selector: #selector(KeyboardViewController.backspaceRepeatCallback),
                                                         userInfo: nil,
                                                         repeats: true)
    }
    
    func backspaceRepeatCallback() {
        playKeySound()
        textDocumentProxy.deleteBackward()
        textInterpreter.removeLastReceiveCharacter()
        setCapsIfNeeded()
    }
    
    
    private func pressShiftDown(_ sender: KeyboardViewItem) {
        print("\(#function)")
        switch shiftState {
        case .disabled:
            shiftState = .enabled
        case .enabled:
            shiftState = .disabled
        case .locked:
            shiftState = .disabled
        }
        
    }
    
    private func doubleTapShift(_ sender: KeyboardViewItem) {
        print("\(#function)")
        switch shiftState {
        case .disabled:
            shiftState = .locked
        case .enabled:
            shiftState = .locked
        case .locked:
            shiftState = .disabled
        }
    }
    
    private func nextKeyboardPage(_ sender: KeyboardViewItem) {
        print("\(#function)")
        guard let page = sender.key.toMode else {return}
        keyboardView.keyboardPage = page
    }
    
    private func pressSettings(_ sender: KeyboardViewItem) {
        print("\(#function)")
        let vc = CipherSettingViewController()
        vc.delegate = self
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalTransitionStyle = .crossDissolve
        nvc.navigationBar.tintColor = UIColor.topBarInscriptColor
        nvc.navigationBar.barTintColor = UIColor.topBarBackgroundColor
        vc.view.backgroundColor = UIColor.keyboardViewBackgroundColor
        present(nvc, animated: true, completion: nil)
    }
    
    private func pressAnOutputItem(_ sender: KeyboardViewItem) {
        print("\(#function)")
        guard let key = sender.key else { return }
        let outputCharacter = key.outputForCase(self.shiftState.isUppercase)
        
        textDocumentProxy.insertText(outputCharacter)
        
        if key.isAlphabet {
            textInterpreter.receiveACharacter(char: outputCharacter)
        } else {
            if let text = encryptedTextLabel.text {
                let characterCount = textInterpreter.receivedCharacters.count
                for _ in 0...characterCount {textDocumentProxy.deleteBackward()}
                textDocumentProxy.insertText(text+outputCharacter)
                textInterpreter.resetState()
                topBar.resetLabels()
            }
            
            //textInterpreter.resetState()
            //topBar.resetLabels()
        }
        
        if key.type == .punctuation {
            delay(0.2) {
                self.keyboardView.keyboardPage = 0
            }
        }
        
        handleAutoPeriod(key)
        setCapsIfNeeded()
    }
    
    private func highlightItem(_ sender: KeyboardViewItem) {
        print("\(#function)")
        sender.highlighted = true
    }
    
    private func unhighlightItem(_ sender: KeyboardViewItem) {
        print("\(#function)")
        sender.highlighted = false
    }
    
    private func playClickSound(_ sender: KeyboardViewItem){
        print("\(#function)")
        playKeySound()
    }
    
    // this only works if full access is enabled
    private func playKeySound() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            AudioServicesPlaySystemSound(1104)
        }
    }
}




