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
import ExtSwift


// MARK: -
// MARK: Keyboard View Delegate Extension
extension KeyboardViewController {
    
    func keyboardViewEventBinding() {
        
    }
    
    
    
    /// Handle view mode output signal
    internal override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.outputs.keyboardDiagram.observeValues { [weak self] in self?.keyboardView.keyboardDiagram = $0 }
        viewModel.outputs.changeToSystemKeyboard.observeValues{ [weak self] in self?.advanceToNextInputMode() }
        viewModel.outputs.deleteCharacterBackward.observeValues{ [weak self] in self?.pressBackspace() }
        viewModel.outputs.stopDeletingCharacterBackward.observeValues { [weak self] in self?.pressBackspaceCancel()}
        viewModel.outputs.highlightKey.observeValues{[weak self] in self?.highlight(true, key: $0)}
        viewModel.outputs.unhighlightKey.observeValues{[weak self] in self?.highlight(false, key: $0)}
        viewModel.outputs.outputOneKey.observeValues{[weak self] in self?.pressAnOutputItem($0)}
        viewModel.outputs.clickSound.observeValues{[weak self] in self?.playKeySound()}
        viewModel.outputs.goToSetting.observeValues {[weak self] in self?.gotoSetting()}
        viewModel.outputs.shiftDown.observeValues{[weak self] in self?.pressShiftDown()}
        viewModel.outputs.shiftDoubletapped.observeValues{[weak self] in self?.doubleTapShift()}
    }
    
    
    
    
    private func pressShiftDown() {
        switch shiftState {
        case .disabled:
            shiftState = .enabled
        case .enabled:
            shiftState = .disabled
        case .locked:
            shiftState = .disabled
        }
    }
    
    private func doubleTapShift() {
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
        guard let mode = sender.key.toMode else {return}
        viewModel.inputs.changeKeyboard(mode)
        
    }
    
    private func gotoSetting() {
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
    private func pressBackspace() {
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
    
    private func cancelBackspaceTimers() {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        backspaceDelayTimer = nil
        backspaceRepeatTimer = nil
    }
    
    private func pressBackspaceCancel() {
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

    /// Output a character forward
    private func pressAnOutputItem(_ key: Key) {
//        guard let key = sender.key else { return }
        let outputCharacter = key.outputForCase(self.shiftState.isUppercase)
        
        textDocumentProxy.insertText(outputCharacter)
        
        if key.isAlphabet {
            textInterpreter.receiveACharacter(char: outputCharacter)
        } else {
            if let text = encryptedLabel.text {
                let characterCount = textInterpreter.receivedCharacters.count
                for _ in 0...characterCount {textDocumentProxy.deleteBackward()}
                textDocumentProxy.insertText(text+outputCharacter)
                textInterpreter.resetState()
            }
        }
        
        if key.type == .punctuation {
            delay(0.2) {
                self.viewModel.inputs.changeKeyboard(.defaultKeyboard)
            }
        }
        
        handleAutoPeriod(key)
        setCapsIfNeeded()
    }
    
    func discardAllInput() {
        textInterpreter.resetState()

    }
    
    private func highlight(_ b: Bool, key: Key) {
        keyboardView.subviews.forEach { (subView) in
            guard let sv = subView as? KeyboardViewItem else { return }
            if sv.key == key {
                sv.highlighted = b
            }
        }
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




