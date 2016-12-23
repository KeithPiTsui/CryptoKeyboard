//
//  CipherManager.swift
//  CryptoKeyboard
//
//  Created by Pi on 14/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

struct CipherManager {
    static let ciphers: [CipherType: Endecryting.Type] = [.caesar:CaesarCipher.self, .keyword:KeywordCipher.self, .vigenere:VigenereCipher.self, .morse:MorseCode.self]
    
    static func encrypt(message: String, withKey key: String? = nil, andCipherType type: CipherType) throws -> String {
        do {
            let key = key ?? ciphers[type]!.defaultKey
            return try ciphers[type]!.encrypt(message: message, withKey: key)
        } catch let e {
            throw e
        }
    }
    
    static func decrypt(message: String, withKey key: String? = nil, andCipherType type: CipherType) throws -> String {
        do {
            let key = key ?? ciphers[type]!.defaultKey
            return try ciphers[type]!.decrypt(message: message, withKey: key)
        } catch let e {
            throw e
        }
    }
}
