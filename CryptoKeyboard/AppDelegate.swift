//
//  AppDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 09/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

var GloabalKeyboardShiftState: ShiftState = .disabled

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        let v = KeyboardSettingInstructionViewController()
//        v.delegate = self
        let v = CipherTranslatorViewController(cipherType: .caesar, cipherKey: "03")
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window!.rootViewController = v
        window!.makeKeyAndVisible()
        
        //testMorseCodeTranslation()
        
        
        return true
    }
}

extension AppDelegate: KeyboardSettingInstructionViewControllerDelegate {
    func KeyboardSettingInstructionViewControllerClosed(_ viewController: KeyboardSettingInstructionViewController) {
        UIView.animate(withDuration: 0.2, animations: { 
            viewController.view.alpha = 0
        }) { (succeed) in
            
            let vc = CipherIntroductionViewController()
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            self.window!.rootViewController = nvc
            self.window!.rootViewController!.view.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.window!.rootViewController!.view.alpha = 1
            }
        }
    }
}

func testMorseCodeTranslation() {
    let message = "I am Kei.th ."
    if let morseCode = try? CipherManager.encrypt(message: message, withKey: "", andCipherType: .morse) {
        let backMessage = try? CipherManager.decrypt(message: morseCode, withKey: "", andCipherType: .morse)
        print(message)
        print(morseCode)
        print("\(backMessage)")
    }
    
}
