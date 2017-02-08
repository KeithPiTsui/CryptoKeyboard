//
//  AppDelegate.swift
//  CryptoKeyboard
//
//  Created by Pi on 09/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit
import Darwin

var GloabalKeyboardShiftState: ShiftState = .disabled

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let nvc = KeyboardSettingInstructionViewController()
        nvc.delegate = self
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window!.rootViewController = nvc
        window!.makeKeyAndVisible()
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
            nvc.navigationBar.tintColor = UIColor.white
            nvc.navigationBar.barTintColor = UIColor(100,65,165)
            nvc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
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
    
    var age: Int = 0
    print("Type your age:")
    
    withUnsafePointer(to: &age) {
        vscanf("%ld", getVaList([OpaquePointer($0)]))
    }
    
    print("Your typed age is \(age)")
}


func scanInt() -> Int? {
    let tmpNumPointer = UnsafeMutablePointer<CInt>.allocate(capacity: 1)
    let valist = getVaList([OpaquePointer(tmpNumPointer)])
    let rtn = vscanf("%d", valist)
    if rtn == -1 {
        // examine the errno global variable to get the error as defined in errno.h
        // if you want to handle or report the error
        return nil
    }
    let returnVal = Int(tmpNumPointer.pointee)
    tmpNumPointer.deallocate(capacity: 1)
    return returnVal
}

















