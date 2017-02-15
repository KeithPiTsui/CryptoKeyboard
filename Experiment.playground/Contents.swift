//: Playground - noun: a place where people can play

import UIKit
import Runes
import KTKeyboard

extension UIViewController {
    public static var defaultNib: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
    
    public static var storyboardIdentifier: String {
        let x = self.description()
        print(x)
        let xs = x.components(separatedBy: ".")
        print(xs)
        let s = xs.dropFirst().joined(separator: ".")
        print(s)
        
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}


let x = {$0+1} <^> [1,2,3]
let kb = Keyboard.numberPunctuationKeyboardDiagram

let u = UIViewController.storyboardIdentifier

class KeyboardViewController: UIViewController {
    
}

let x2 = KeyboardViewController.storyboardIdentifier

let x9 = HelloWorld.greeting