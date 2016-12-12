//
//  KeyboardViewController+InputInterpreterOutputReceiverDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

extension KeyboardViewController: InputInterpreterOutputReceiverDelegate {
    func receiveOutputCharacter(char: String) {
        print("Received a encrypted message: \(char)")
        let orgText = topBar.middleLabel.text ?? ""
        topBar.middleLabel.text = orgText + char
    }
    
    func removeLastOutputCharacter() {
        
    }
}
