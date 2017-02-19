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
        leftChars.append(char)
    }
    
    func receiveEncryptedOutputCharacter(char: String) {
        rightChars.append(char)
    }
    
    func receiveDecryptedOutputCharacter(char: String) {
        
    }
    
    func removeLastOutputCharacter() {
        if leftChars.isEmpty == false { leftChars.removeLast() }
        if rightChars.isEmpty == false { rightChars.removeLast() }
    }
}

















































