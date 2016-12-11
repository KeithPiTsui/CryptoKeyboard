
//
//  KeyboardLayoutHelper.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

fileprivate var keyRepresentations:
[(type: Key.KeyType, meaning: String?, inscript: String?, mode: Int?, column: Int, row: Int, page: Int)]? = [
(.character,    "Q",    nil,    nil,    0, 0, 0),
(.character,    "W",    nil,    nil,    1, 0, 0),
(.character,    "E",    nil,    nil,    2, 0, 0),
(.character,    "R",    nil,    nil,    3, 0, 0),
(.character,    "T",    nil,    nil,    4, 0 ,0),
(.character,    "Y",    nil,    nil,    5, 0 ,0),
(.character,    "U",    nil,    nil,    6, 0 ,0),
(.character,    "I",    nil,    nil,    7, 0 ,0),
(.character,    "O",    nil,    nil,    8, 0 ,0),
(.character,    "P",    nil,    nil,    9, 0 ,0),

(.character,    "A",    nil,    nil,    0, 1 ,0),
(.character,    "S",    nil,    nil,    1, 1 ,0),
(.character,    "D",    nil,    nil,    2, 1 ,0),
(.character,    "F",    nil,    nil,    3, 1 ,0),
(.character,    "G",    nil,    nil,    4, 1 ,0),
(.character,    "H",    nil,    nil,    5, 1 ,0),
(.character,    "J",    nil,    nil,    6, 1 ,0),
(.character,    "K",    nil,    nil,    7, 1 ,0),
(.character,    "L",    nil,    nil,    8, 1 ,0),

(.shift,        nil,    nil,    nil,    0, 2 ,0),
(.character,    "Z",    nil,    nil,    1, 2 ,0),
(.character,    "X",    nil,    nil,    2, 2 ,0),
(.character,    "C",    nil,    nil,    3, 2 ,0),
(.character,    "V",    nil,    nil,    4, 2 ,0),
(.character,    "B",    nil,    nil,    5, 2 ,0),
(.character,    "N",    nil,    nil,    6, 2 ,0),
(.character,    "M",    nil,    nil,    7, 2 ,0),
(.backspace,    nil,    nil,    nil,    8, 2 ,0),

(.modeChange,   nil,  "123",    1,      0, 3 ,0),
(.keyboardChange, nil,  nil,    nil,    1, 3 ,0),
(.settings,     nil,    nil,    nil,    2, 3 ,0),
(.space,        " ","space",    nil,    3, 3 ,0),
(.return,      "\n","Return",   nil,    4, 3 ,0),

(.specialCharacter,"1", nil,    nil,    0, 0 ,1),
(.specialCharacter,"2", nil,    nil,    1, 0 ,1),
(.specialCharacter,"3", nil,    nil,    2, 0 ,1),
(.specialCharacter,"4", nil,    nil,    3, 0 ,1),
(.specialCharacter,"5", nil,    nil,    4, 0 ,1),
(.specialCharacter,"6", nil,    nil,    5, 0 ,1),
(.specialCharacter,"7", nil,    nil,    6, 0 ,1),
(.specialCharacter,"8", nil,    nil,    7, 0 ,1),
(.specialCharacter,"9", nil,    nil,    8, 0 ,1),
(.specialCharacter,"0", nil,    nil,    9, 0 ,1),

(.specialCharacter,"-", nil,    nil,    0, 1 ,1),
(.specialCharacter,"/", nil,    nil,    1, 1 ,1),
(.specialCharacter,":", nil,    nil,    2, 1 ,1),
(.specialCharacter,";", nil,    nil,    3, 1 ,1),
(.specialCharacter,"(", nil,    nil,    4, 1 ,1),
(.specialCharacter,")", nil,    nil,    5, 1 ,1),
(.specialCharacter,"$", nil,    nil,    6, 1 ,1),
(.specialCharacter,"&", nil,    nil,    7, 1 ,1),
(.specialCharacter,"@", nil,    nil,    8, 1 ,1),
(.specialCharacter,"\"",nil,    nil,    9, 1 ,1),

(.modeChange,   nil,  "#+=",    2,      0, 2 ,1),
(.specialCharacter,".", nil,    nil,    1, 2 ,1),
(.specialCharacter,",", nil,    nil,    2, 2 ,1),
(.specialCharacter,"?", nil,    nil,    3, 2 ,1),
(.specialCharacter,"!", nil,    nil,    4, 2 ,1),
(.specialCharacter,"'", nil,    nil,    5, 2 ,1),
(.backspace,       nil, nil,    nil,    6, 2 ,1),

(.modeChange,   nil,  "ABC",    0,      0, 3 ,1),
(.keyboardChange,   nil,nil,    nil,    1, 3 ,1),
(.settings,         nil,nil,    nil,    2, 3 ,1),
(.space,        " ","space",    nil,    3, 3 ,1),
(.return,      "\n","Return",   nil,    4, 3 ,1),

(.specialCharacter,"[", nil,    nil,    0, 0 ,2),
(.specialCharacter,"]", nil,    nil,    1, 0 ,2),
(.specialCharacter,"{", nil,    nil,    2, 0 ,2),
(.specialCharacter,"}", nil,    nil,    3, 0 ,2),
(.specialCharacter,"#", nil,    nil,    4, 0 ,2),
(.specialCharacter,"%", nil,    nil,    5, 0 ,2),
(.specialCharacter,"^", nil,    nil,    6, 0 ,2),
(.specialCharacter,"*", nil,    nil,    7, 0 ,2),
(.specialCharacter,"+", nil,    nil,    8, 0 ,2),
(.specialCharacter,"=", nil,    nil,    9, 0 ,2),

(.specialCharacter,"_", nil,    nil,    0, 1 ,2),
(.specialCharacter,"\\",nil,    nil,    1, 1 ,2),
(.specialCharacter,"|", nil,    nil,    2, 1 ,2),
(.specialCharacter,"~", nil,    nil,    3, 1 ,2),
(.specialCharacter,"<", nil,    nil,    4, 1 ,2),
(.specialCharacter,">", nil,    nil,    5, 1 ,2),
(.specialCharacter,"€", nil,    nil,    6, 1 ,2),
(.specialCharacter,"£", nil,    nil,    7, 1 ,2),
(.specialCharacter,"¥", nil,    nil,    8, 1 ,2),
(.specialCharacter,"•", nil,    nil,    9, 1 ,2),

(.modeChange,   nil,  "123",    1,      0, 2 ,2),
(.specialCharacter,".", nil,    nil,    1, 2 ,2),
(.specialCharacter,",", nil,    nil,    2, 2 ,2),
(.specialCharacter,"?", nil,    nil,    3, 2 ,2),
(.specialCharacter,"!", nil,    nil,    4, 2 ,2),
(.specialCharacter,"'", nil,    nil,    5, 2 ,2),
(.backspace,       nil, nil,    nil,    6, 2 ,2),

(.modeChange,   nil,  "ABC",    0,      0, 3 ,2),
(.keyboardChange,   nil,nil,    nil,    1, 3 ,2),
(.settings,         nil,nil,    nil,    2, 3 ,2),
(.space,        " ","space",    nil,    3, 3 ,2),
(.return,      "\n","Return",   nil,    4, 3 ,2),
]


extension Keyboard {
    static let defaultKeyboard: Keyboard =  {
        assert(keyRepresentations != nil, "Key Representations must not be nil")
        var defaultKeyboard = Keyboard(columns: 10, rows: 4, pages: 3)
        for keyRep in keyRepresentations! {
            defaultKeyboard.keys[keyRep.page][keyRep.row][keyRep.column]
                = Key(type: keyRep.type, meaning: keyRep.meaning, inscript: keyRep.inscript, mode: keyRep.mode)
        }
        keyRepresentations = nil
        return defaultKeyboard
    }()
}



















