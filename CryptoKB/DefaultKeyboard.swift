
//
//  KeyboardLayoutHelper.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

extension Keyboard {
    
    static let symbols = "[]{}#%^*+=-\\|~<>€£¥•"
    static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let puncutations = ".,?!'"
    static let numbers = "1234567890"

    static let defaultKeyboardDiagram: Diagram = {
        return "QWERTYUIOP".diagram
            --- 0.5 ||| "ASDFGHJKL".diagram ||| 0.5
            --- "shift><1.2" ||| 0.1 ||| "ZXCVBNM".diagram ||| 0.1 ||| "backspace><1.2"
            --- ["modechange", "keyboardchange", "settings", "space><4", "return><2"].hcat
    }()
 
    static let numberKeyboardDiagram: Diagram = {
        return "123".diagram --- "456".diagram --- "789".diagram --- 1 ||| "0" ||| "backspace"
    }()
    
    static let alphaKeyboardDiagram: Diagram = {
        return "QWERTYUIOP".diagram
            --- 0.5 ||| "ASDFGHJKL".diagram ||| 0.5
            --- "shift><1.2" ||| 0.1 ||| "ZXCVBNM".diagram ||| 0.1 ||| "backspace><1.2"
            --- 1
    }()
}

extension String {
    
    var diagram: Diagram {
        return chars.map{Diagram(stringLiteral: $0)}.hcat
    }
    
    var keyType: Key.KeyType {
        let text = self
        if Keyboard.symbols.contains(text) && text.lengthOfBytes(using: .utf8) == 1 {
            return .symbol
        } else if Keyboard.letters.contains(text) && text.lengthOfBytes(using: .utf8) == 1 {
            return .alphabet
        } else if Keyboard.puncutations.contains(text) && text.lengthOfBytes(using: .utf8) == 1 {
            return .punctuation
        } else if Keyboard.numbers.contains(text) && text.lengthOfBytes(using: .utf8) == 1 {
            return .number
        } else if text == "shift" {
            return .shift
        } else if text == "backspace" {
            return .backspace
        } else if text == "modechange" {
            return .modeChange
        } else if text == "keyboardchange" {
            return  .keyboardChange
        } else if text == "settings" {
            return .settings
        } else if text == "space" {
            return .space
        } else if text == "return" {
            return .return
        } else {
            fatalError("Not a key type representation")
        }
    }
    
    var keyMeaning: String? {
        switch self.keyType {
        case .alphabet, .number, .punctuation, .symbol:
            return self
        case .space:
            return " "
        case .return:
            return "\n"
        default:
            return nil
        }
    }
    
    var keyInscript: String? {
        switch self.keyType {
        case .modeChange:
            return "123"
        case .return:
            return "Ret"
        default:
            return nil
        }
    }
    
    var key: Key {
        return Key(type: self.keyType, meaning: self.keyMeaning, inscript: self.keyInscript, mode: nil)
    }
}













