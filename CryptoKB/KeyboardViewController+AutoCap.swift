//
//  KeyboardViewController+TypingDecoration.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

extension KeyboardViewController {
    
    @discardableResult
    func setCapsIfNeeded() -> Bool {
        if shouldAutoCapitalize() {
            switch shiftState {
            case .disabled:
                shiftState = .enabled
            case .enabled:
                shiftState = .enabled
            case .locked:
                shiftState = .locked
            }
            
            return true
        } else {
            
            switch shiftState {
            case .disabled:
                shiftState = .disabled
            case .enabled:
                shiftState = .disabled
            case .locked:
                shiftState = .locked
            }
            
            return false
        }
    }
    
    func characterIsPunctuation(_ character: Character) -> Bool {
        return [".","!","?"].contains(character)
    }
    
    private func characterIsNewline(_ character: Character) -> Bool {
        return ["\n", "\r"].contains(character)
    }
    
    func characterIsWhitespace(_ character: Character) -> Bool {
        // there are others, but who cares
        return [" ", "\n", "\r", "\t"].contains(character)
    }
    
    private func stringIsWhitespace(_ string: String?) -> Bool {
        guard let string = string else { return true }
        for char in (string).characters {
            if !characterIsWhitespace(char) {return false}
        }
        return true
    }
    
    private func shouldAutoCapitalize() -> Bool {
        guard let autocapitalization = textDocumentProxy.autocapitalizationType else { return false}
        switch autocapitalization {
        case .none: return false
        case .words:
            guard let beforeContext = textDocumentProxy.documentContextBeforeInput else { return true }
            let previousCharacter = beforeContext[beforeContext.characters.index(before: beforeContext.endIndex)]
            return characterIsWhitespace(previousCharacter)
        case .sentences:
            guard let beforeContext = textDocumentProxy.documentContextBeforeInput else { return true }
            let offset = min(3, beforeContext.characters.count)
            var index = beforeContext.endIndex
            for i in 0 ..< offset {
                index = beforeContext.index(before: index)
                let char = beforeContext[index]
                
                if characterIsPunctuation(char) {
                    return i == 0 ? false : true
                }else {
                    if !characterIsWhitespace(char) {
                        return false //hit a foreign character before getting to 3 spaces
                    } else if characterIsNewline(char) {
                        return true //hit start of line
                    }
                }
            }
            return true //either got 3 spaces or hit start of line
        case .allCharacters: return true
        }
    }

}
