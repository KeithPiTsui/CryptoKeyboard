//
//  KeyboardViewDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

protocol KeyboardViewDelegate: class {
    func changeKeyboard(_ sender: KeyboardViewItem)
    func pressBackspace(_ sender: KeyboardViewItem)
    func pressBackspaceCancel(_ sender: KeyboardViewItem)
    func pressShiftDown(_ sender: KeyboardViewItem)
    func pressShiftUpInside(_ sender: KeyboardViewItem)
    func doubleTapShift(_ sender: KeyboardViewItem)
    func nextKeyboardPage(_ sender: KeyboardViewItem)
    func pressSettings(_ sender: KeyboardViewItem)
    func pressAnOutputItem(_ sender: KeyboardViewItem)
    func highlightItem(_ sender: KeyboardViewItem)
    func unhighlightItem(_ sender: KeyboardViewItem)
    func playClickSound(_ sender: KeyboardViewItem)
}
















