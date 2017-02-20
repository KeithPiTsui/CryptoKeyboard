//
//  KeyboardViewController+CipherSettingViewControllerDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 14/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

extension KeyboardViewController: CipherSettingViewControllerDelegate {
    func didSelect(cipherName: String, cipherType: CipherType, cipherKey: String) {
        self.cipherName = cipherName
        self.cipherType = cipherType
        self.cipherKey = cipherKey
        syncCipherSetting()
        discardAllInput()
        textInterpreter.resetAll()
    }
    
    private func syncCipherSetting () {
        UserDefaults.standard.setValue(cipherType.rawValue, forKey: KeyboardExtensionConstants.cipherType)
        UserDefaults.standard.setValue(cipherName, forKey: KeyboardExtensionConstants.cipherName)
        UserDefaults.standard.setValue(cipherKey, forKey: KeyboardExtensionConstants.cipherKey)
        UserDefaults.standard.synchronize()
    }
    
    func cancelSelect() {
        
    }
}
