//
//  KeyboardViewController+AutoSuffixPeriod.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

enum AutoPeriodState {
    case noSpace
    case firstSpace
}

extension KeyboardViewController {
    func handleAutoPeriod(_ key: Key) {
        if autoPeriodState == .firstSpace {
            if key.type != .space {
                autoPeriodState = .noSpace
                return
            }
            
            let charactersAreInCorrectState = { () -> Bool in
                let previousContext = textDocumentProxy.documentContextBeforeInput
                
                if previousContext == nil || (previousContext!).characters.count < 3 {
                    return false
                }
                
                var index = previousContext!.endIndex
                
                index = previousContext!.index(before: index)
                if previousContext![index] != " " {
                    return false
                }
                
                index = previousContext!.index(before: index)
                if previousContext![index] != " " {
                    return false
                }
                
                index = previousContext!.index(before: index)
                let char = previousContext![index]
                if characterIsWhitespace(char) || characterIsPunctuation(char) || char == "," {
                    return false
                }
                
                return true
            }()
            
            if charactersAreInCorrectState {
                textDocumentProxy.deleteBackward()
                textDocumentProxy.deleteBackward()
                textDocumentProxy.insertText(".")
                textDocumentProxy.insertText(" ")
            }
            autoPeriodState = .noSpace
        }
        else {
            if key.type == .space {
                autoPeriodState = .firstSpace
            }
        }
    }

}
