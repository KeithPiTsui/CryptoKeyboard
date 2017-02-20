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
    func receiveHeuristicOutputCharacter(char: String)
    func receiveEncryptedOutputCharacter(char: String)
    func receiveDecryptedOutputCharacter(char: String)
    func removeLastOutputCharacter()
}

final class InputInterpreter: InputInterpreterProtocol {
    
    weak var delegate: InputInterpreterOutputReceiverDelegate?
    var archivedCharacters: [[String]] = []
    var receivedCharacters: [String] = []
    var cipherType: CipherType = .caesar
    var cipherKey: String = "3"
    
    init(delegate: InputInterpreterOutputReceiverDelegate? = nil) {
        self.delegate = delegate
    }
    
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
        archivedCharacters.append(receivedCharacters)
        receivedCharacters.removeAll(keepingCapacity: true)
    }
    
    func resetAll() {
        receivedCharacters.removeAll(keepingCapacity: true)
        archivedCharacters.removeAll(keepingCapacity: true)
    }
    
    
    private func translateIntoCipherOf(cipherType: CipherType, andKey key: String) {
        if cipherType == .keyword || cipherType == .vigenere {
            guard let delegate = delegate else { return }
            let message = archivedCharacters.flatMap{$0}.reduce("", +) + receivedCharacters.reduce("", +)
            if let secret = try? CipherManager.encrypt(message: message, withKey: key, andCipherType: cipherType) {
                delegate.receiveEncryptedOutputCharacter(char: secret.chars.last!)
            }
            
            if let plaintext = try? CipherManager.decrypt(message: message, withKey: key, andCipherType: cipherType) {
                delegate.receiveDecryptedOutputCharacter(char: plaintext.chars.last!)
            }
            delegate.receiveHeuristicOutputCharacter(char: receivedCharacters.last!)
        } else {
            guard let message = receivedCharacters.last, let delegate = delegate else { return }
            if let secret = try? CipherManager.encrypt(message: message, withKey: key, andCipherType: cipherType) {
                delegate.receiveEncryptedOutputCharacter(char: secret)
            }
            
            if let plaintext = try? CipherManager.decrypt(message: message, withKey: key, andCipherType: cipherType) {
                delegate.receiveDecryptedOutputCharacter(char: plaintext)
            }
            delegate.receiveHeuristicOutputCharacter(char: message)
            
        }
    }
}




















