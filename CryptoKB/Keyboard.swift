import UIKit
import Library

public struct Keyboard {
    
    public enum Mode {
        case defaultKeyboard
        case numberPunctuationKeyboard
        case numberSymbolKeyboard
        case alphaKeyboard
        case numericKeyboard
    }
    
    public static let symbols = "()[]{}#%^*+=-\\|~<>€£¥•/:&$@_"
    public static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    public static let puncutations = ".,?!';\""
    public static let numbers = "1234567890"
    
    //
    public static let numberPunctuationKeyboardDiagram: Diagram<Key> = {
        let a = "123456789" --- "-/:;()$&@\""
        let c = "modechangeSym" ||| 0.1 ||| ".,?!'" ||| 0.1 ||| "backspace><1.2"
        let d = "modechangeABC" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
        return a --- c --- d
    }()
    //
    public static let symbolKeyboardDiagram: Diagram<Key> = {
        
        let a = "[]{}#%^*+=" --- "_\\|~<>€£¥•"
        let c = "modechange123" ||| 0.1 ||| ".,?!'" ||| 0.1 ||| "backspace><1.2"
        let d = "modechangeABC" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
        
        return a --- c --- d
    }()
    ////
    public static let defaultKeyboardDiagram: Diagram<Key> = {
        let a = "QWERTYUIOP" --- 0.5 ||| "ASDFGHJKL" ||| 0.5
        let c = "shift><1.2" ||| 0.1 ||| "ZXCVBNM" ||| 0.1 ||| "backspace><1.2"
        let d = "modechange123" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
        
        return a --- c --- d
    }()
    
    
    public static let alphaKeyboardDiagram: Diagram<Key> = {
        return "QWERTYUIOP"
            --- 0.5 ||| "ASDFGHJKL" ||| 0.5
            --- "shift><1.2" ||| 0.1 ||| "ZXCVBNM" ||| 0.1 ||| "backspace><1.2"
            --- 1
    }()
    
    public static let numberKeyboardDiagram: Diagram<Key> = {
        return "123" --- "456" --- "789" --- 1 ||| "0" ||| "backspace"
    }()
    
    fileprivate static let keywords: [String] = ["shift", "backspace","modechange123","modechangeABC","modechangeSym","keyboardchange","space","return", "settings"]
}



extension String {
    fileprivate var compositeDiagram: Diagram<Key> {
        return chars.map{ $0.singularDiagram }.reduce(Diagram()){$0 ||| $1}
    }
    
    fileprivate var singularDiagram: Diagram<Key> {
        let values = self.components(separatedBy: "><")
        guard values.count >= 1 && values.count <= 3 else { fatalError("keyboard layout syntax error") }
        let key: Key = Key(stringLiteral: values.first!)
        if values.count == 1 {
            return .primitive(CGSize.one, .element(key))
        } else if values.count == 2 {
            guard let w = Double(values[1]) else { fatalError("keyboard layout syntax error") }
            return .primitive(CGSize(width: w, height: 1), .element(key))
        } else if values.count == 3 {
            guard let w = Double(values[1]) else { fatalError("keyboard layout syntax error") }
            guard let h = Double(values[2]) else { fatalError("keyboard layout syntax error") }
            return .primitive(CGSize(width: w, height: h), .element(key))
        } else {
            fatalError("keyboard layout syntax error")
        }
    }
    
    fileprivate var diagram: Diagram<Key> {
        guard let value = self.components(separatedBy: "><").first else { fatalError("keyboard layout syntax error") }
        return Keyboard.keywords.contains(value) ? self.singularDiagram : self.compositeDiagram
    }
    
    fileprivate static func ||| (g: CGFloat, r: String) -> Diagram<Key> {
        return .beside(Diagram(), g, r.diagram)
    }
    
    fileprivate static func ||| (l: String, g: CGFloat) -> Diagram<Key> {
        return .beside(l.diagram, g, Diagram())
    }
    
    fileprivate static func ||| (l: String, r: String) -> Diagram<Key> {
        return .beside(l.diagram, 0, r.diagram)
    }
    
    fileprivate static func ||| (l: String, r: Diagram<Key>) -> Diagram<Key> {
        return .beside(l.diagram, 0, r)
    }
    
    fileprivate static func ||| (l: Diagram<Key>, r: String) -> Diagram<Key> {
        return .beside(l, 0, r.diagram)
    }
    
    
    fileprivate static func --- (g: CGFloat, r: String) -> Diagram<Key> {
        return .below(Diagram(), g, r.diagram)
    }
    
    fileprivate static func --- (l: String, g: CGFloat) -> Diagram<Key> {
        return .below(l.diagram, g, Diagram())
    }
    
    
    fileprivate static func --- (l: String, r: String) -> Diagram<Key> {
        return .below(l.diagram, 0, r.diagram)
    }
    
    fileprivate static func --- (l: Diagram<Key>, r: String) -> Diagram<Key> {
        return .below(l, 0, r.diagram)
    }
    
    fileprivate static func --- (l: String, r: Diagram<Key>) -> Diagram<Key> {
        return .below(l.diagram, 0, r)
    }
}

















