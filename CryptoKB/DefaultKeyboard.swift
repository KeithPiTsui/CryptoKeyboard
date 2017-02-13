
//
//  KeyboardLayoutHelper.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

fileprivate var numericKeyRepresentations:
    [(type: Key.KeyType, meaning: String?, inscript: String?, mode: Int?, column: Int, row: Int, page: Int)]? = [
        (.number,"1", nil,    nil,    0, 0 ,0),
        (.number,"2", nil,    nil,    1, 0 ,0),
        (.number,"3", nil,    nil,    2, 0 ,0),
        (.number,"4", nil,    nil,    0, 1 ,0),
        (.number,"5", nil,    nil,    1, 1 ,0),
        (.number,"6", nil,    nil,    2, 1 ,0),
        (.number,"7", nil,    nil,    0, 2 ,0),
        (.number,"8", nil,    nil,    1, 2 ,0),
        (.number,"9", nil,    nil,    2, 2 ,0),
        (.number,"0", nil,    nil,    0, 3 ,0),
        (.backspace,    nil,    nil,    nil,    1, 3 ,0)]

fileprivate var alphabetKeyRepresentations:
    [(type: Key.KeyType, meaning: String?, inscript: String?, mode: Int?, column: Int, row: Int, page: Int)]? = [
        (.alphabet,    "Q",    nil,    nil,    0, 0, 0),
        (.alphabet,    "W",    nil,    nil,    1, 0, 0),
        (.alphabet,    "E",    nil,    nil,    2, 0, 0),
        (.alphabet,    "R",    nil,    nil,    3, 0, 0),
        (.alphabet,    "T",    nil,    nil,    4, 0 ,0),
        (.alphabet,    "Y",    nil,    nil,    5, 0 ,0),
        (.alphabet,    "U",    nil,    nil,    6, 0 ,0),
        (.alphabet,    "I",    nil,    nil,    7, 0 ,0),
        (.alphabet,    "O",    nil,    nil,    8, 0 ,0),
        (.alphabet,    "P",    nil,    nil,    9, 0 ,0),
        
        (.alphabet,    "A",    nil,    nil,    0, 1 ,0),
        (.alphabet,    "S",    nil,    nil,    1, 1 ,0),
        (.alphabet,    "D",    nil,    nil,    2, 1 ,0),
        (.alphabet,    "F",    nil,    nil,    3, 1 ,0),
        (.alphabet,    "G",    nil,    nil,    4, 1 ,0),
        (.alphabet,    "H",    nil,    nil,    5, 1 ,0),
        (.alphabet,    "J",    nil,    nil,    6, 1 ,0),
        (.alphabet,    "K",    nil,    nil,    7, 1 ,0),
        (.alphabet,    "L",    nil,    nil,    8, 1 ,0),
        
        (.shift,        nil,    nil,    nil,    0, 2 ,0),
        (.alphabet,    "Z",    nil,    nil,    1, 2 ,0),
        (.alphabet,    "X",    nil,    nil,    2, 2 ,0),
        (.alphabet,    "C",    nil,    nil,    3, 2 ,0),
        (.alphabet,    "V",    nil,    nil,    4, 2 ,0),
        (.alphabet,    "B",    nil,    nil,    5, 2 ,0),
        (.alphabet,    "N",    nil,    nil,    6, 2 ,0),
        (.alphabet,    "M",    nil,    nil,    7, 2 ,0),
        (.backspace,    nil,    nil,    nil,    8, 2 ,0)]

fileprivate var keyRepresentations:
[(type: Key.KeyType, meaning: String?, inscript: String?, mode: Int?, column: Int, row: Int, page: Int)]? = [
(.alphabet,    "Q",    nil,    nil,    0, 0, 0),
(.alphabet,    "W",    nil,    nil,    1, 0, 0),
(.alphabet,    "E",    nil,    nil,    2, 0, 0),
(.alphabet,    "R",    nil,    nil,    3, 0, 0),
(.alphabet,    "T",    nil,    nil,    4, 0 ,0),
(.alphabet,    "Y",    nil,    nil,    5, 0 ,0),
(.alphabet,    "U",    nil,    nil,    6, 0 ,0),
(.alphabet,    "I",    nil,    nil,    7, 0 ,0),
(.alphabet,    "O",    nil,    nil,    8, 0 ,0),
(.alphabet,    "P",    nil,    nil,    9, 0 ,0),

(.alphabet,    "A",    nil,    nil,    0, 1 ,0),
(.alphabet,    "S",    nil,    nil,    1, 1 ,0),
(.alphabet,    "D",    nil,    nil,    2, 1 ,0),
(.alphabet,    "F",    nil,    nil,    3, 1 ,0),
(.alphabet,    "G",    nil,    nil,    4, 1 ,0),
(.alphabet,    "H",    nil,    nil,    5, 1 ,0),
(.alphabet,    "J",    nil,    nil,    6, 1 ,0),
(.alphabet,    "K",    nil,    nil,    7, 1 ,0),
(.alphabet,    "L",    nil,    nil,    8, 1 ,0),

(.shift,        nil,    nil,    nil,    0, 2 ,0),
(.alphabet,    "Z",    nil,    nil,    1, 2 ,0),
(.alphabet,    "X",    nil,    nil,    2, 2 ,0),
(.alphabet,    "C",    nil,    nil,    3, 2 ,0),
(.alphabet,    "V",    nil,    nil,    4, 2 ,0),
(.alphabet,    "B",    nil,    nil,    5, 2 ,0),
(.alphabet,    "N",    nil,    nil,    6, 2 ,0),
(.alphabet,    "M",    nil,    nil,    7, 2 ,0),
(.backspace,    nil,    nil,    nil,    8, 2 ,0),

(.modeChange,   nil,  "123",    1,      0, 3 ,0),
(.keyboardChange, nil,  nil,    nil,    1, 3 ,0),
(.settings,     nil,    nil,    nil,    2, 3 ,0),
(.space,        " ",    nil,    nil,    3, 3 ,0),
(.return,      "\n","Ret",   nil,    4, 3 ,0),

(.number,"1", nil,    nil,    0, 0 ,1),
(.number,"2", nil,    nil,    1, 0 ,1),
(.number,"3", nil,    nil,    2, 0 ,1),
(.number,"4", nil,    nil,    3, 0 ,1),
(.number,"5", nil,    nil,    4, 0 ,1),
(.number,"6", nil,    nil,    5, 0 ,1),
(.number,"7", nil,    nil,    6, 0 ,1),
(.number,"8", nil,    nil,    7, 0 ,1),
(.number,"9", nil,    nil,    8, 0 ,1),
(.number,"0", nil,    nil,    9, 0 ,1),

(.symbol,"-", nil,    nil,    0, 1 ,1),
(.symbol,"/", nil,    nil,    1, 1 ,1),
(.punctuation,":", nil,    nil,    2, 1 ,1),
(.punctuation,";", nil,    nil,    3, 1 ,1),
(.symbol,"(", nil,    nil,    4, 1 ,1),
(.symbol,")", nil,    nil,    5, 1 ,1),
(.symbol,"$", nil,    nil,    6, 1 ,1),
(.symbol,"&", nil,    nil,    7, 1 ,1),
(.symbol,"@", nil,    nil,    8, 1 ,1),
(.symbol,"\"",nil,    nil,    9, 1 ,1),

(.modeChange,   nil,  "#+=",    2,      0, 2 ,1),
(.punctuation,".", nil,    nil,    1, 2 ,1),
(.punctuation,",", nil,    nil,    2, 2 ,1),
(.punctuation,"?", nil,    nil,    3, 2 ,1),
(.punctuation,"!", nil,    nil,    4, 2 ,1),
(.punctuation,"'", nil,    nil,    5, 2 ,1),
(.backspace,       nil, nil,    nil,    6, 2 ,1),

(.modeChange,   nil,  "ABC",    0,      0, 3 ,1),
(.keyboardChange,   nil,nil,    nil,    1, 3 ,1),
(.settings,         nil,nil,    nil,    2, 3 ,1),
(.space,        " ",    nil,    nil,    3, 3 ,1),
(.return,      "\n","Return",   nil,    4, 3 ,1),

(.symbol,"[", nil,    nil,    0, 0 ,2),
(.symbol,"]", nil,    nil,    1, 0 ,2),
(.symbol,"{", nil,    nil,    2, 0 ,2),
(.symbol,"}", nil,    nil,    3, 0 ,2),
(.symbol,"#", nil,    nil,    4, 0 ,2),
(.symbol,"%", nil,    nil,    5, 0 ,2),
(.symbol,"^", nil,    nil,    6, 0 ,2),
(.symbol,"*", nil,    nil,    7, 0 ,2),
(.symbol,"+", nil,    nil,    8, 0 ,2),
(.symbol,"=", nil,    nil,    9, 0 ,2),

(.symbol,"_", nil,    nil,    0, 1 ,2),
(.symbol,"\\",nil,    nil,    1, 1 ,2),
(.symbol,"|", nil,    nil,    2, 1 ,2),
(.symbol,"~", nil,    nil,    3, 1 ,2),
(.symbol,"<", nil,    nil,    4, 1 ,2),
(.symbol,">", nil,    nil,    5, 1 ,2),
(.symbol,"€", nil,    nil,    6, 1 ,2),
(.symbol,"£", nil,    nil,    7, 1 ,2),
(.symbol,"¥", nil,    nil,    8, 1 ,2),
(.symbol,"•", nil,    nil,    9, 1 ,2),

(.modeChange,   nil,  "123",    1,      0, 2 ,2),
(.punctuation,".", nil,    nil,    1, 2 ,2),
(.punctuation,",", nil,    nil,    2, 2 ,2),
(.punctuation,"?", nil,    nil,    3, 2 ,2),
(.punctuation,"!", nil,    nil,    4, 2 ,2),
(.punctuation,"'", nil,    nil,    5, 2 ,2),
(.backspace,       nil, nil,    nil,    6, 2 ,2),

(.modeChange,   nil,  "ABC",    0,      0, 3 ,2),
(.keyboardChange,   nil,nil,    nil,    1, 3 ,2),
(.settings,         nil,nil,    nil,    2, 3 ,2),
(.space,        " ",    nil,    nil,    3, 3 ,2),
(.return,      "\n","Return",   nil,    4, 3 ,2),
]


extension Keyboard {
    
    static let symbols = "[]{}#%^*+=-\\|~<>€£¥•"
    static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let puncutations = ".,?!'"
    static let numbers = "1234567890"
    
    static let defaultKeyboard: Keyboard =  {
        assert(keyRepresentations != nil, "Key Representations must not be nil")
        var defaultKeyboard = Keyboard(columns: 10, rows: 4, pages: 3)
        for keyRep in keyRepresentations! {
            defaultKeyboard.keys[keyRep.page][keyRep.row][keyRep.column]
                = Key(type: keyRep.type, meaning: keyRep.meaning, inscript: keyRep.inscript, mode: keyRep.mode)
        }
        return defaultKeyboard
    }()
    
    static let alphabetKeyboard: Keyboard = {
        assert(alphabetKeyRepresentations != nil, "Key Representations must not be nil")
        var defaultKeyboard = Keyboard(columns: 10, rows: 3, pages: 1)
        for keyRep in alphabetKeyRepresentations! {
            defaultKeyboard.keys[keyRep.page][keyRep.row][keyRep.column]
                = Key(type: keyRep.type, meaning: keyRep.meaning, inscript: keyRep.inscript, mode: keyRep.mode)
        }
        alphabetKeyRepresentations = nil
        return defaultKeyboard
    }()
    
    static let numericKeyboard: Keyboard = {
        assert(numericKeyRepresentations != nil, "Key Representations must not be nil")
        var defaultKeyboard = Keyboard(columns: 3, rows: 4, pages: 1)
        for keyRep in numericKeyRepresentations! {
            defaultKeyboard.keys[keyRep.page][keyRep.row][keyRep.column]
                = Key(type: keyRep.type, meaning: keyRep.meaning, inscript: keyRep.inscript, mode: keyRep.mode)
        }
        numericKeyRepresentations = nil
        return defaultKeyboard
    }()

    static let defaultKeyboardDiagram: Diagram = {
        return "Q"|||"W"|||"E"|||"R"|||"T"|||"Y"|||"U"|||"I"|||"O"|||"P"
                --- 0.5 ||| "A"|||"S"|||"D"|||"F"|||"G"|||"H"|||"J"|||"K"|||"L" ||| 0.5
                --- "shift><1.2" ||| 0.1 ||| "Z"|||"X"|||"C"|||"V"|||"B"|||"N"|||"M" ||| 0.1 ||| "backspace><1.2"
                --- "modechange" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
    }()
 
    static let numberKeyboardDiagram: Diagram = {
        return "1" ||| "2" ||| "3" --- "4" ||| "5" ||| "6" --- "7" ||| "8" ||| "9" --- 1 ||| "0" ||| "backspace"
    }()
    
    static let alphaKeyboardDiagram: Diagram = {
        return "Q"|||"W"|||"E"|||"R"|||"T"|||"Y"|||"U"|||"I"|||"O"|||"P"
            --- 0.5 ||| "A"|||"S"|||"D"|||"F"|||"G"|||"H"|||"J"|||"K"|||"L" ||| 0.5
            --- "shift><1.2" ||| 0.1 ||| "Z"|||"X"|||"C"|||"V"|||"B"|||"N"|||"M" ||| 0.1 ||| "backspace><1.2"
            --- 1
    }()
}

extension String {
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













