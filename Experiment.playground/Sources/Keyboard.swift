import UIKit

public struct Keyboard {
    public static let symbols = "()[]{}#%^*+=-\\|~<>€£¥•/:&$@_"
    public static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    public static let puncutations = ".,?!';\""
    public static let numbers = "1234567890"
    
    
    public static let numberPunctuationKeyboardDiagram: Diagram<Key> = {
        return "123456789"
            --- "-/:;()$&@\""
            --- "modechangeSym" ||| 0.1 ||| ".,?!'" ||| 0.1 ||| "backspace><1.2"
            --- "modechangeABC" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
    }()
//
    public static let symbolKeyboardDiagram: Diagram<Key> = {
        return "[]{}#%^*+="
            --- "_\\|~<>€£¥•"
            --- "modechange123" ||| 0.1 ||| ".,?!'" ||| 0.1 ||| "backspace><1.2"
            --- "modechangeABC" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
    }()
//
    public static let defaultKeyboardDiagram: Diagram<Key> = {
        return "QWERTYUIOP"
            --- 0.5 ||| "ASDFGHJKL" ||| 0.5
            --- "shift><1.2" ||| 0.1 ||| "ZXCVBNM" ||| 0.1 ||| "backspace><1.2"
            --- "modechange123" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
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
    
    static let keywords: [String] = ["shift", "backspace","modechange123","modechangeABC","modechangeSym","keyboardchange","space","return"]
}



extension String {
    var compositeDiagram: Diagram<Key> {
        return chars.map{ $0.singularDiagram }.reduce(Diagram()){$0 ||| $1}
    }
    
    var singularDiagram: Diagram<Key> {
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
    
    var diagram: Diagram<Key> {
        guard let value = self.components(separatedBy: "><").first else { fatalError("keyboard layout syntax error") }
        return Keyboard.keywords.contains(value) ? self.singularDiagram : self.compositeDiagram
    }
    
    static func ||| (g: CGFloat, r: String) -> Diagram<Key> {
        return .beside(Diagram(), g, r.diagram)
    }
    
    static func ||| (l: String, g: CGFloat) -> Diagram<Key> {
        return .beside(l.diagram, g, Diagram())
    }
    
    static func ||| (l: String, r: String) -> Diagram<Key> {
        return .beside(l.diagram, 0, r.diagram)
    }
    
    static func ||| (l: String, r: Diagram<Key>) -> Diagram<Key> {
        return .beside(l.diagram, 0, r)
    }
    
    static func ||| (l: Diagram<Key>, r: String) -> Diagram<Key> {
        return .beside(l, 0, r.diagram)
    }
    
    
    static func --- (g: CGFloat, r: String) -> Diagram<Key> {
        return .below(Diagram(), g, r.diagram)
    }
    
    static func --- (l: String, g: CGFloat) -> Diagram<Key> {
        return .below(l.diagram, g, Diagram())
    }
    
    
    static func --- (l: String, r: String) -> Diagram<Key> {
        return .below(l.diagram, 0, r.diagram)
    }
    
    static func --- (l: Diagram<Key>, r: String) -> Diagram<Key> {
        return .below(l, 0, r.diagram)
    }
    
    static func --- (l: String, r: Diagram<Key>) -> Diagram<Key> {
        return .below(l.diagram, 0, r)
    }
}

















