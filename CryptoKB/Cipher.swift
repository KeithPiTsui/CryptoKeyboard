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

enum CipherType: Int {
    case caesar
    case morse
    case vigenere
    case keyword
}

enum CipherKeyType {
    case number
    case letter
    case none
}


/// Including Encryption and Decryption
protocol Endecryting {
    static var name: String {get}
    static var digits: UInt {get}
    static var keyType: CipherKeyType {get}
    static var defaultKey: String {get}
    static func encrypt(message: String, withKey key: String) throws -> String;
    static func decrypt(message: String, withKey key: String) throws -> String;
}

fileprivate let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".chars;

struct CaesarCipher: Endecryting {
    static let defaultKey: String = "3"
    static let digits: UInt = 2
    static let name: String = "Caesar"
    static let keyType: CipherKeyType = .number
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
fileprivate var morseCodeMapReverse: [String:String] = [:]


struct MorseCode: Endecryting {
    static let defaultKey: String = ""
    static let name: String = "Morse"
    static let digits: UInt = 0
    static let keyType: CipherKeyType = .none
    
    static func encrypt(message: String, withKey key: String) throws -> String {
        return message.uppercased().chars.reduce("") { (initializer: String, element: String) -> String in
            var str = element; let isLetter = letters.contains(element)
            if let mappedStr = morseCodeMap[element] {
                str = mappedStr
            }
            if element == " " { str += "  "}
            else if isLetter { str += " "}
            return initializer + str
        }
    }
    
    enum ScalarType {
        case dotDash
        case blank
        case other
        
        init(_ scalar: Character) {
            if "•-".characters.contains(scalar) {
                self = .dotDash
            } else if scalar == " " {
                self = .blank
            } else {
                self = .other
            }
        }
    }
    
    
    static func decrypt(message: String, withKey key: String) throws -> String {
        if morseCodeMapReverse.isEmpty {
            morseCodeMap.forEach{morseCodeMapReverse[$1] = $0}
        }
        
        var words:[String] = []
        var word:[Character] = []
        var previousScalar: Character = message[message.startIndex]
        word.append(previousScalar)
        for (idx, scalar) in message.characters.enumerated() {
            guard idx != 0 else { continue}
            if ScalarType(previousScalar) == ScalarType(scalar) {
                word.append(scalar)
            } else {
                words.append(word.map{String($0)}.joined())
                word.removeAll(keepingCapacity: true)
                word.append(scalar)
            }
            previousScalar = scalar
        }
        words.append(word.map{String($0)}.joined())

        let translatedSplits = words.map { (morseCodeStr) -> String in
            if let mapped = morseCodeMapReverse[morseCodeStr] {
                return mapped
            } else if morseCodeStr.contains(" ") {
                if morseCodeStr.characters.count == 1 {
                    return ""
                } else {
                    return " "
                }
            } else {
                return morseCodeStr
            }
        }
        
        return translatedSplits.joined()
    }
}


extension CharacterSet {
    static let alphabet: CharacterSet = {return CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")}()
}

fileprivate let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars

struct VigenereCipher: Endecryting {
    static let defaultKey: String = "Hello"
    static let name: String = "Vigenere"
    static let digits: UInt = 5
    static let keyType: CipherKeyType = .letter
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
    static let defaultKey: String = "Hello"
    static let name: String = "Keyword"
    static let digits: UInt = 5
    static let keyType: CipherKeyType = .letter
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













