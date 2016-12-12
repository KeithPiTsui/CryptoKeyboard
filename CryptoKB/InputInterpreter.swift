//
//  InputInterpreter.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

protocol InputInterpreterProtocol {
    weak var delegate: InputInterpreterOutputReceiverDelegate? {get set}
    func receiveACharacter(char: String)
    func removeLastReceiveCharacter()
    func resetState()
}

protocol InputInterpreterOutputReceiverDelegate: class {
    func receiveOutputCharacter(char: String)
    func removeLastOutputCharacter()
}

class InputInterpreter: InputInterpreterProtocol {
    
    weak var delegate: InputInterpreterOutputReceiverDelegate?
    
    var receivedCharacters: [String] = []
    var cipherType: CipherType = .caesar
    var cipherKey: String = "3"
    
    func receiveACharacter(char: String) {
        receivedCharacters.append(char)
        translateIntoCipherOf(cipherType: cipherType, andKey: cipherKey)
    }
    
    func removeLastReceiveCharacter() {
        if receivedCharacters.isEmpty == false {
            receivedCharacters.removeLast()
        }
        delegate?.removeLastOutputCharacter()
    }
    
    func resetState() {
        receivedCharacters.removeAll(keepingCapacity: true)
    }
    
    private func translateIntoCipherOf(cipherType: CipherType, andKey key: String) {
        guard let message = receivedCharacters.last, let delegate = delegate else { return }
        if let message = try? CipherManager.sharedInstance().encryptMessage(message, with: cipherType, andKey: key) {
            delegate.receiveOutputCharacter(char: message)
        }
    }
    
}








