//
//  Storyboard.swift
//  CryptoKeyboard
//
//  Created by Pi on 16/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit

extension Bundle {
    /// Returns an NSBundle pinned to the framework target. We could choose anything for the `forClass`
    /// parameter as long as it is in the framework target.
    internal static var framework: Bundle {
        return Bundle(for: AboutCryptoKeyboardViewModel.self)
    }
}

public enum Storyboard: String {
    case AboutCryptoKeyboard
    case CipherInterpreter
    
    
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type, inBundle bundle: Bundle = .framework) -> VC {
        guard
            let vc = UIStoryboard(name: self.rawValue, bundle: Bundle(identifier: bundle.identifier))
                .instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
            else { fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)") }
        
        return vc
    }
}
