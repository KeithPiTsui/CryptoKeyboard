//
//  KeyboardViewController+TopBarViewDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 12/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

extension KeyboardViewController: TopBarViewDelegate {
    func topBarLabel(_ label: UILabel, receivedEvent event: UIControlEvents, inTopBar topBar: TopBarView) {
        guard let text = label.text, event == .touchUpInside else { return }
        let characterCount = textInterpreter.receivedCharacters.count
        for _ in 0..<characterCount {textDocumentProxy.deleteBackward()}
        textDocumentProxy.insertText(text+" ")
        textInterpreter.resetState()
        topBar.resetLabels()
    }
}
