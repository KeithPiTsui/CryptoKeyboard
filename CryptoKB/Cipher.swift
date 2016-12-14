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

enum CipherType: Int, Hashable {
    case caesar
    case morse
    case Vigenere
    case keyword
    var hashValue: Int { return self.rawValue }
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
            var str = element; let isLetter = letters.contains(element)
            if let mappedStr = morseCodeMap[element] {
                str = mappedStr
            }
            if element == " " { str += "    "}
            else if isLetter { str += "  "}
            return initializer + str
        }
    }
    
    static func decrypt(message: String, withKey key: String) throws -> String {
       
        return ""
    }
}


extension CharacterSet {
    static let alphabet: CharacterSet = {
        return CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    }()
}

fileprivate let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars

struct VigenereCipher: Endecryting {
    
    static let name: String = "Vigenere"
    
    static func encrypt(message: String, withKey key: String) throws -> String {
        guard key.isEmpty == false else { return message }
        guard key.trimmingCharacters(in: CharacterSet.alphabet).isEmpty else { throw EndecError.invalidKey}
        var keys = key.uppercased().chars
        var keyIndex = 0
        return message.uppercased().chars.reduce("") { (initializer: String, element: String) -> String in
            var str = element
            let K = keys[keyIndex%keys.count]
            if let Mi = uppercaseLetters.index(of: element), let Ki = uppercaseLetters.index(of: K) {
                let Ei = (Mi + Ki) % 26
                str = uppercaseLetters[Ei]
            }
            
            if CharacterSet.alphabet.contains(element.unicodeScalars.first!) {
                keyIndex += 1
            }
            return initializer + str
        }
    }
    
    static func decrypt(message: String, withKey key: String) throws -> String {
        guard key.isEmpty == false else { return message }
        guard key.trimmingCharacters(in: CharacterSet.alphabet).isEmpty else { throw EndecError.invalidKey}
        var keys = key.uppercased().chars
        var keyIndex = 0
        return message.uppercased().chars.reduce("") { (initializer: String, element: String) -> String in
            var str = element
            let K = keys[keyIndex%keys.count]
            if let Ci = uppercaseLetters.index(of: element), let Ki = uppercaseLetters.index(of: K) {
                let Ei = ((Ci - Ki) % 26 + 26) % 26
                str = uppercaseLetters[Ei]
            }
            
            if CharacterSet.alphabet.contains(element.unicodeScalars.first!) {
                keyIndex += 1
            }
            return initializer + str
        }
    }
}


struct KeywordCipher: Endecryting {
    static let name: String = "Keyword"
    
    static func encrypt(message: String, withKey key: String) throws -> String {
        guard key.isEmpty == false else { return message }
        guard key.trimmingCharacters(in: CharacterSet.alphabet).isEmpty else { throw EndecError.invalidKey}

        let keys = Set(key.uppercased().chars)
        var mapping = Array(keys).sorted()
        mapping.append(contentsOf: uppercaseLetters.filter {!keys.contains($0)})

        return message.uppercased().chars.reduce("") { (initializer: String, element: String) -> String in
            var str = element
            if let idx = uppercaseLetters.index(of: element) {
                str = mapping[idx]
            }
            return initializer + str
        }
    }
    
    static func decrypt(message: String, withKey key: String) throws -> String {
        
        guard key.isEmpty == false else { return message }
        guard key.trimmingCharacters(in: CharacterSet.alphabet).isEmpty else { throw EndecError.invalidKey}
        
        let keys = Set(key.uppercased().chars)
        var mapping = Array(keys).sorted()
        mapping.append(contentsOf: uppercaseLetters.filter {!keys.contains($0)})
        
        return message.uppercased().chars.reduce("") { (initializer: String, element: String) -> String in
            var str = element
            if let idx = mapping.index(of: element) {
                str = uppercaseLetters[idx]
            }
            return initializer + str
        }
    }
}























