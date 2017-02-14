//
//  KeyboardViewController+KeyboardViewDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit
import AudioToolbox
import ReactiveSwift
import ReactiveCocoa
import Result


// MARK: -
// MARK: Keyboard View Delegate Extension
extension KeyboardViewController {
    
    func keyboardViewEventBinding() {
        bind(.touchUpInside, to: .keyboardChange, with: self.changeKeyboard)
        
        bind(.touchDown, to: .backspace, with: self.pressBackspace)
        bind(.touchDragExit, to: .backspace, with: self.pressBackspaceCancel)
        bind(.touchUpOutside, to: .backspace, with: self.pressBackspaceCancel)
        bind(.touchCancel, to: .backspace, with: self.pressBackspaceCancel)
        bind(.touchDragOutside, to: .backspace, with: self.pressBackspaceCancel)
        bind(.touchUpInside, to: .backspace, with: self.pressBackspaceCancel)
        
        bind(.touchDown, to: .shift, with: self.pressShiftDown)
        bind(.touchDownRepeat, to: .shift, with: self.doubleTapShift)
        bind(.touchUpInside, to: .modeChange, with: self.nextKeyboardPage)
        bind(.touchUpInside, to: .settings, with: self.pressSettings)
        
        keyboardView.reactive.controlEvents(.touchDown).filter{$0.key.isHighlightable}.observeValues{self.highlightItem($0)}
        keyboardView.reactive.controlEvents(.touchDragInside).filter{$0.key.isHighlightable}.observeValues{self.highlightItem($0)}
        keyboardView.reactive.controlEvents(.touchDragEnter).filter{$0.key.isHighlightable}.observeValues{self.highlightItem($0)}
        
        keyboardView.reactive.controlEvents(.touchUpInside).filter{$0.key.isHighlightable}.observeValues{self.unhighlightItem($0)}
        keyboardView.reactive.controlEvents(.touchUpOutside).filter{$0.key.isHighlightable}.observeValues{self.unhighlightItem($0)}
        keyboardView.reactive.controlEvents(.touchDragOutside).filter{$0.key.isHighlightable}.observeValues{self.unhighlightItem($0)}
        
        keyboardView.reactive.controlEvents(.touchUpInside).filter{$0.key.hasOutput}.observeValues{self.pressAnOutputItem($0)}
        keyboardView.reactive.controlEvents(.touchDown).observeValues{self.playClickSound($0)}
    }
    
    func bind(_ event: UIControlEvents, to keyType: Key.KeyType, with action: @escaping (KeyboardViewItem) -> Void) {
        keyboardView.reactive.controlEvents(event).filter{$0.key.type == keyType}.observeValues{action($0)}
    }
    
    
    private func changeKeyboard(_ sender: KeyboardViewItem) {
        advanceToNextInputMode()
    }
    
    
    
    private func pressShiftDown(_ sender: KeyboardViewItem) {
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
//        guard let page = sender.key.toMode else {return}
    }
    
    private func pressSettings(_ sender: KeyboardViewItem) {
        let vc = CipherSettingViewController(cipherName: cipherName, cipherType: cipherType, cipherKey: cipherKey)
        vc.delegate = self
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalTransitionStyle = .crossDissolve
        nvc.navigationBar.tintColor = UIColor.topBarInscriptColor
        nvc.navigationBar.barTintColor = UIColor.topBarBackgroundColor
        vc.view.backgroundColor = UIColor.keyboardViewBackgroundColor
        present(nvc, animated: true, completion: nil)
    }
    
    /// Delete a character backward
    private func pressBackspace(_ sender: KeyboardViewItem) {
        print("\(#function)")
        deleteACharacterBackward()
        textInterpreter.removeLastReceiveCharacter()
        setCapsIfNeeded()
        // trigger for subsequent deletes
        backspaceDelayTimer = Timer.scheduledTimer(timeInterval: backspaceDelay - backspaceRepeat,
                                                   target: self,
                                                   selector: #selector(KeyboardViewController.backspaceDelayCallback),
                                                   userInfo: nil,
                                                   repeats: false)
    }
    
    private func cancelBackspaceTimers() {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        backspaceDelayTimer = nil
        backspaceRepeatTimer = nil
    }
    
    private func pressBackspaceCancel(_ sender: KeyboardViewItem) {
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
        deleteACharacterBackward()
        textInterpreter.removeLastReceiveCharacter()
        setCapsIfNeeded()
    }
    
    private func deleteACharacterBackward(){
        textDocumentProxy.deleteBackward()
    }

    /// Output a character forward
    private func pressAnOutputItem(_ sender: KeyboardViewItem) {
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
        }
        
        if key.type == .punctuation {
            delay(0.2) {
//                self.keyboardView.keyboardPage = 0
            }
        }
        
        handleAutoPeriod(key)
        setCapsIfNeeded()
    }
    
    func discardAllInput() {
        textInterpreter.resetState()
        topBar.resetLabels()
    }
    
    private func highlightItem(_ sender: KeyboardViewItem) {
        sender.highlighted = true
    }
    
    private func unhighlightItem(_ sender: KeyboardViewItem) {
        sender.highlighted = false
    }
    
    private func playClickSound(_ sender: KeyboardViewItem){
        playKeySound()
    }
    
    // this only works if full access is enabled
    private func playKeySound() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            AudioServicesPlaySystemSound(1104)
        }
    }
}




