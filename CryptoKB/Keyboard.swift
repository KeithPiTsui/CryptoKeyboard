//
//  KeyboardLayoutHelper.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

enum ShiftState {
    case disabled
    case enabled
    case locked
    
    var isUppercase: Bool {
        switch self {
        case .disabled:
            return false
        case .enabled, .locked:
            return true
        }
    }
}

struct Key: Hashable, CustomStringConvertible {
    private static var counter = sequence(first: 0) { $0 + 1 }
    let hashValue: Int = Key.counter.next()!
    var description: String { return "\(self.hashValue)"}
    
    enum KeyType: UInt {
        case shift
        case backspace
        case modeChange
        case keyboardChange
        case space
        case `return`
        case settings
        case alphabet
        case number
        case symbol
        case punctuation
    }
    
    static let highlightableKeyTypes:[KeyType] = [.alphabet, .number, .symbol, .punctuation, .space]
    static let iconKeyType:[KeyType] = [.shift, .backspace, .keyboardChange, .settings, .return]
    
    let type: KeyType
    let meaning: String?
    let inscript: String?
    let toMode: Int?
    
    var uppercaseKeyCap: String? {return self.inscript?.uppercased()}
    var lowercaseKeyCap: String? {return self.inscript?.lowercased()}
    var uppercaseOutput: String? {return self.meaning?.uppercased()}
    var lowercaseOutput: String? {return self.meaning?.lowercased()}
    
    var isAlphabet: Bool {return type == .alphabet}
    var isHighlightable: Bool { return Key.highlightableKeyTypes.contains(type) }
    
    var withIcon: Bool { return Key.iconKeyType.contains(type) }
    var hasOutput: Bool { return meaning != nil }
    
    
    init(type: KeyType, meaning: String? = nil,  inscript: String? = nil, mode: Int? = nil) {
        self.type = type
        self.meaning = meaning
        self.inscript = inscript ?? meaning
        self.toMode = mode
    }
    
    func outputForCase(_ uppercase: Bool) -> String {
        return uppercase ? (self.uppercaseOutput ?? self.lowercaseOutput ?? "")
                         : (self.lowercaseOutput ?? self.uppercaseOutput ?? "")
    }
    
    func keyCapForCase(_ uppercase: Bool) -> String {
        return uppercase ? (self.uppercaseKeyCap ?? self.lowercaseKeyCap ?? "")
                         : (self.lowercaseKeyCap ?? self.uppercaseKeyCap ?? "")
    }
    
    static func == (lhs: Key, rhs: Key) -> Bool { return lhs.hashValue == rhs.hashValue }
}























