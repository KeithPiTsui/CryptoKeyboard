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

public extension SignalProtocol {
    public func observeForUI() -> Signal<Value, Error> {
        return self.signal.observe(on: UIScheduler())
    }
}


extension KeyboardViewController {
    
    /// Handle view mode output signal
    internal override func bindViewModel() {
        super.bindViewModel()
        viewModel.outputs.keyboardDiagram
            .observeForUI()
            .observeValues{[weak self] in self?.keyboardView.keyboardDiagram = $0 }
        viewModel.outputs.changeToSystemKeyboard
            .observeForUI()
            .observeValues{[weak self] in self?.advanceToNextInputMode() }
        viewModel.outputs.deleteCharacterBackward
            .observeForUI()
            .observeValues{[weak self] in self?.pressBackspace() }
        viewModel.outputs.stopDeletingCharacterBackward
            .observeForUI()
            .observeValues{[weak self] in self?.pressBackspaceCancel()}
        viewModel.outputs.highlightKey
            .observeForUI()
            .observeValues{[weak self] in self?.highlight(true, key: $0)}
        viewModel.outputs.unhighlightKey
            .observeForUI()
            .observeValues{[weak self] in self?.highlight(false, key: $0)}
        viewModel.outputs.outputOneKey
            .observeForUI()
            .observeValues{[weak self] in self?.pressAnOutputItem($0)}
        viewModel.outputs.clickSound
            .observeForUI()
            .observeValues{[weak self] in self?.playKeySound()}
        viewModel.outputs.goToSetting
            .observeForUI()
            .observeValues{[weak self] in self?.gotoSetting()}
        viewModel.outputs.shiftDown
            .observeForUI()
            .observeValues{[weak self] in self?.pressShiftDown()}
        viewModel.outputs.shiftDoubletapped
            .observeForUI()
            .observeValues{[weak self] in self?.doubleTapShift()}
        
        heuristicBtn.reactive.controlEvents(.touchUpInside).observe { (_) in print("Hello")}
        keyboardView.reactive.controlEvents(.allTouchEvents).observeValues{ [weak self] in self?.viewModel.inputs.event($0.1, on: $0.0.key)}
    }
    
    
    private func pressShiftDown() {
        shiftState = shiftState == .disabled ? .enabled : .disabled
    }
    
    private func doubleTapShift() {
        shiftState = shiftState == .locked ? .disabled : .locked
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
        let outputCharacter = key.outputForCase(self.shiftState.isUppercase)
        textDocumentProxy.insertText(outputCharacter)
        if key.isAlphabet { textInterpreter.receiveACharacter(char: outputCharacter)
        } else if let text = encryptedLabel.text {
            let characterCount = textInterpreter.receivedCharacters.count
            for _ in 0...characterCount {textDocumentProxy.deleteBackward()}
            textDocumentProxy.insertText(text+outputCharacter)
            textInterpreter.resetState()
        }
        
        if key.type == .punctuation {
            delay(0.2) { [weak self] in self?.viewModel.inputs.changeKeyboard(.defaultKeyboard) }
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
            if sv.key == key { sv.highlighted = b }
        }
    }
    
    // this only works if full access is enabled
    private func playKeySound() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { AudioServicesPlaySystemSound(1104)}
    }
}




