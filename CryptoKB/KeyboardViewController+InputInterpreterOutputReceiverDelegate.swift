//
//  KeyboardViewController+InputInterpreterOutputReceiverDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

extension KeyboardViewController: InputInterpreterOutputReceiverDelegate {
    
    func receiveHeuristicOutputCharacter(char: String) {
        heuristicTextLabel.text = (heuristicTextLabel.text ?? "") + char
    }
    
    func receiveEncryptedOutputCharacter(char: String) {
        encryptedTextLabel.text = (encryptedTextLabel.text ?? "") + char
    }
    
    func receiveDecryptedOutputCharacter(char: String) {
        decryptedTextLabel.text = (decryptedTextLabel.text ?? "") + char
    }
    
    func removeLastOutputCharacter() {
        for label in [heuristicTextLabel, encryptedTextLabel, decryptedTextLabel] {
            if label.text != nil && label.text!.isEmpty == false {
                var text = label.text!
                text.remove(at: text.index(before: text.endIndex))
                label.text = text
            }
        }
    }
}
