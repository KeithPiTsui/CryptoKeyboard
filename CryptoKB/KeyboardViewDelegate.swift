//
//  KeyboardViewDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate: class {
    func keyboardViewItem(_ item: KeyboardViewItem,
                          receivedEvent event: UIControlEvents,
                          inKeyboard keyboard: KeyboardView)
}
















