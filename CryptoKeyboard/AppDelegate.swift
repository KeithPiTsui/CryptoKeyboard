//
//  AppDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 09/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let v = KeyboardSettingInstructionViewController()
        v.delegate = self
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window!.rootViewController = v
        window!.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate: KeyboardSettingInstructionViewControllerDelegate {
    func KeyboardSettingInstructionViewControllerClosed(_ viewController: KeyboardSettingInstructionViewController) {
        UIView.animate(withDuration: 0.2, animations: { 
            viewController.view.alpha = 0
        }) { (succeed) in
            self.window!.rootViewController = CipherIntroductionViewController()
            self.window!.rootViewController!.view.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.window!.rootViewController!.view.alpha = 1
            }
        }
    }
}

