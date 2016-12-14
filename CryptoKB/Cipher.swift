//
//  Cipher.swift
//  CryptoKeyboard
//
//  Created by Pi on 14/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

enum EndecError: Error {
    case invalidKey
}

enum CipherType {
    case caesar
    case morse
}

/// Including Encryption and Decryption
protocol Endecryting {
    static var name: String {get}
    static func encrypt(message: String, withKey key: String) throws -> String;
    static func decrypt(message: String, withKey key: String) throws -> String;
}

extension String {
    var chars: [String] {
        return self.characters.reduce([]) {(initializer:[String], element: Character) -> [String] in
            var strings = initializer
            strings.append("\(element)")
            return strings
        }
    }
}

fileprivate let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".chars;

struct CaesarCipher: Endecryting {
    
    static let name: String = "CaesarCipher"
    static func encrypt(message: String, withKey key: String) throws -> String {
        guard let keyNumberValue = Int(key) else { throw EndecError.invalidKey }
        if keyNumberValue ==  0 { return message }
        
        var secret: String = ""
        for char in message.chars {
            var encryptedChar = char
            if var idx = letters.index(of: char) {
                idx = (idx + keyNumberValue) % letters.count
                encryptedChar = letters[idx]
            }
            secret.append(encryptedChar)
        }
        return secret
    }
    
    static func decrypt(message: String, withKey key: String) throws -> String {
        guard let keyNumberValue = Int(key) else { throw EndecError.invalidKey }
        if keyNumberValue ==  0 { return message }
        var plaintext: String = ""
        for char in message.chars {
            var encryptedChar = char
            if var idx = letters.index(of: char) {
                idx = (idx - keyNumberValue) % letters.count
                idx = (letters.count + idx) % letters.count
                encryptedChar = letters[idx]
            }
            plaintext.append(encryptedChar)
        }
        return plaintext
    }
}

fileprivate func loadMorseCodeMap() -> [String:String]{
    let filePath = Bundle.main.path(forResource: "MorseCodeMapping", ofType: "json")!
    let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
    let jsonDict = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! Dictionary<String, String>
    return jsonDict
}

fileprivate let morseCodeMap = loadMorseCodeMap()



struct MorseCode: Endecryting {
    static let name: String = "MorseCode"
    
    static func encrypt(message: String, withKey key: String) throws -> String {
        return message.uppercased().chars.reduce("") { (initializer: String, element: String) -> String in
            let org = initializer
            let char = element
            
            var str = char
            let isLetter = letters.contains(char)
            if let mappedStr = morseCodeMap[char] {
                str = mappedStr
            }
            if char == " " {
                str += "    "
            } else if isLetter {
                str += "  "
            }
            return org + str
        }
    }
    
    static func decrypt(message: String, withKey key: String) throws -> String {
       
        return ""
    }
}


























