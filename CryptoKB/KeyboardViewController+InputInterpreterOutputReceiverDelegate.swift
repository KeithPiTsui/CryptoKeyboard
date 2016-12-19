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
        topBar.leftCharacters.append(char)
    }
    
    func receiveEncryptedOutputCharacter(char: String) {
        topBar.rightCharacters.append(char)
    }
    
    func receiveDecryptedOutputCharacter(char: String) {
        
    }
    
    func removeLastOutputCharacter() {
        if topBar.leftCharacters.isEmpty == false {
            topBar.leftCharacters.removeLast()
        }
        if topBar.rightCharacters.isEmpty == false {
            topBar.rightCharacters.removeLast()
        }
    }
}
