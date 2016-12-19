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
        window = UIWindow()
        window!.rootViewController = v
        window!.makeKeyAndVisible()
        return true
    }
}

