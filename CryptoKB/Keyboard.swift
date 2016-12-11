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

struct Keyboard {
    var keys: [[[Key?]]]
    init(columns: Int, rows: Int, pages: Int) {
        var pageArr = Array<[[Key?]]>()
        for _ in 1...pages {
            var rowArr = Array<[Key?]>()
            for _ in 1...rows {
                let columnArr = Array<Key?>(repeating: nil, count: columns)
                rowArr.append(columnArr)
            }
            pageArr.append(rowArr)
        }
        keys = pageArr
    }
}

struct Key: Hashable, CustomStringConvertible {
    enum KeyType: UInt {
        case character = 0
        case specialCharacter
        case shift
        case backspace
        case modeChange
        case keyboardChange
        case period
        case space
        case `return`
        case settings
    }
    
    static let characterKeyTypes:[KeyType] = [.character, .specialCharacter, .period]
    static let specialKeyTypes:[KeyType] = [.shift, .backspace, .modeChange, .keyboardChange, .return, .settings]
    static let iconKeyType:[KeyType] = [.shift, .backspace, .keyboardChange]
    var description: String { return "\(self.hashValue)"}
    private static var counter = sequence(first: 0) { $0 + 1 }
    let hashValue: Int = Key.counter.next()!
    
    let type: KeyType
    let meaning: String?
    let inscript: String?
    let toMode: Int?
    
    var uppercaseKeyCap: String? {return self.inscript?.uppercased()}
    var lowercaseKeyCap: String? {return self.inscript?.lowercased()}
    var uppercaseOutput: String? {return self.meaning?.uppercased()}
    var lowercaseOutput: String? {return self.meaning?.lowercased()}
    
    
    var isCharacter: Bool { return Key.characterKeyTypes.contains(type) }
    var isSpecial: Bool { return Key.specialKeyTypes.contains(type) }
    var withIcon: Bool { return Key.iconKeyType.contains(type) }
    var hasOutput: Bool { return (uppercaseOutput != nil) || (lowercaseOutput != nil) }
    
    
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























