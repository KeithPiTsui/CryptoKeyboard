
//
//  KeyboardLayoutHelper.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

struct Keyboard {
    static let symbols = "()[]{}#%^*+=-\\|~<>€£¥•/:&$@_"
    static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let puncutations = ".,?!';\""
    static let numbers = "1234567890"

    
    static let numberPunctuationKeyboardDiagram: Diagram = {
        return "123456789".diagram
            --- ("-/:;()$&@\"").diagram
            --- "modechangeSym" ||| 0.1 ||| ".,?!'".diagram ||| 0.1 ||| "backspace><1.2"
            --- ["modechangeABC", "keyboardchange", "settings", "space><4", "return><2"].hcat
    }()
    
    static let symbolKeyboardDiagram: Diagram = {
        return "[]{}#%^*+=".diagram
            --- "_\\|~<>€£¥•".diagram
            --- "modechange123" ||| 0.1 ||| ".,?!'".diagram ||| 0.1 ||| "backspace><1.2"
            --- ["modechangeABC", "keyboardchange", "settings", "space><4", "return><2"].hcat
    }()
    
    static let defaultKeyboardDiagram: Diagram = {
        return "QWERTYUIOP".diagram
            --- 0.5 ||| "ASDFGHJKL".diagram ||| 0.5
            --- "shift><1.2" ||| 0.1 ||| "ZXCVBNM".diagram ||| 0.1 ||| "backspace><1.2"
            --- ["modechange123", "keyboardchange", "settings", "space><4", "return><2"].hcat
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
    
    var diagram: Diagram { return chars.map{Diagram(stringLiteral: $0)}.hcat}
    
    var keyType: Key.KeyType {
        let text = self
        if Keyboard.symbols.contains(text) && text.characters.count == 1{
            return .symbol
        } else if Keyboard.letters.contains(text) && text.characters.count == 1 {
            return .alphabet
        } else if Keyboard.puncutations.contains(text) && text.characters.count == 1{
            return .punctuation
        } else if Keyboard.numbers.contains(text) && text.characters.count == 1{
            return .number
        } else if text == "shift" {
            return .shift
        } else if text == "backspace" {
            return .backspace
        } else if text == "modechange123" || text == "modechangeABC" || text == "modechangeSym" {
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
            fatalError("Not a key type representation \(text)")
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
        if self == "modechange123" {
            return "123"
        } else if self == "modechangeABC" {
            return "ABC"
        } else if self == "modechangeSym" {
            return "#+="
        }
        
        switch self.keyType {
        case .return:
            return "Ret"
        default:
            return nil
        }
    }
    
    var key: Key {
        var mode: Int? = nil
        if self == "modechange123" {
            mode = 1
        } else if self == "modechangeABC" {
            mode = 0
        } else if self == "modechangeSym" {
            mode = 2
        }
        return Key(type: self.keyType, meaning: self.keyMeaning, inscript: self.keyInscript, mode: mode)

    }
}













