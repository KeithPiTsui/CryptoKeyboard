import UIKit

public enum ShiftState {
    case disabled
    case enabled
    case locked
    
    public var isUppercase: Bool {
        switch self {
        case .disabled:
            return false
        case .enabled, .locked:
            return true
        }
    }
}

public struct Key: Hashable, CustomStringConvertible {
    private static var counter = sequence(first: 0) { $0 + 1 }
    public let hashValue: Int = Key.counter.next()!
    public var description: String { return "\(self.hashValue)"}
    
    enum KeyType: UInt {
        case shift
        case backspace
        case modeChange
        case keyboardChange
        case space
        case `return`
        case settings
        case alphabet
        case number
        case symbol
        case punctuation
    }
    
    static let highlightableKeyTypes:[KeyType] = [.alphabet, .number, .symbol, .punctuation, .space]
    static let iconKeyType:[KeyType] = [.shift, .backspace, .keyboardChange, .settings, .return]
    
    let type: KeyType
    let meaning: String?
    let inscript: String?
    let toMode: Int?
    
    var uppercaseKeyCap: String? {return self.inscript?.uppercased()}
    var lowercaseKeyCap: String? {return self.inscript?.lowercased()}
    var uppercaseOutput: String? {return self.meaning?.uppercased()}
    var lowercaseOutput: String? {return self.meaning?.lowercased()}
    
    var isAlphabet: Bool {return type == .alphabet}
    var isHighlightable: Bool { return Key.highlightableKeyTypes.contains(type) }
    
    var withIcon: Bool { return Key.iconKeyType.contains(type) }
    var hasOutput: Bool { return meaning != nil }
    
    
    init(type: KeyType, meaning: String? = nil,  inscript: String? = nil, mode: Int? = nil) {
        self.type = type
        self.meaning = meaning
        self.inscript = inscript ?? meaning
        self.toMode = mode
    }
    
    func outputForCase(_ uppercase: Bool) -> String {
        return uppercase ? (self.uppercaseOutput ?? self.lowercaseOutput ?? "")
            : (self.lowercaseOutput ?? self.uppercaseOutput ?? "")
    }
    
    func keyCapForCase(_ uppercase: Bool) -> String {
        return uppercase ? (self.uppercaseKeyCap ?? self.lowercaseKeyCap ?? "")
            : (self.lowercaseKeyCap ?? self.uppercaseKeyCap ?? "")
    }
    
    public static func == (lhs: Key, rhs: Key) -> Bool { return lhs.hashValue == rhs.hashValue }
}

extension Key: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        var mode: Int? = nil
        if value == "modechange123" {
            mode = 1
        } else if value == "modechangeABC" {
            mode = 0
        } else if value == "modechangeSym" {
            mode = 2
        }
        self.init(type: value.keyType, meaning: value.keyMeaning, inscript: value.keyInscript, mode: mode)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
}

extension String {
    var keyType: Key.KeyType {
        let text = self
        if Keyboard.symbols.contains(text) && text.characters.count == 1{
            return .symbol
        } else if Keyboard.letters.contains(text) && text.characters.count == 1 {
            return .alphabet
        } else if Keyboard.puncutations.contains(text) && text.characters.count == 1{
            return .punctuation
        } else if Keyboard.numbers.contains(text) && text.characters.count == 1{
            return .number
        } else if text == "shift" {
            return .shift
        } else if text == "backspace" {
            return .backspace
        } else if text == "modechange123" || text == "modechangeABC" || text == "modechangeSym" {
            return .modeChange
        } else if text == "keyboardchange" {
            return  .keyboardChange
        } else if text == "settings" {
            return .settings
        } else if text == "space" {
            return .space
        } else if text == "return" {
            return .return
        } else {
            fatalError("Not a key type representation \(text)")
        }
    }
    
    var keyMeaning: String? {
        switch self.keyType {
        case .alphabet, .number, .punctuation, .symbol:
            return self
        case .space:
            return " "
        case .return:
            return "\n"
        default:
            return nil
        }
    }
    
    var keyInscript: String? {
        if self == "modechange123" {
            return "123"
        } else if self == "modechangeABC" {
            return "ABC"
        } else if self == "modechangeSym" {
            return "#+="
        }
        
        switch self.keyType {
        case .return:
            return "Ret"
        default:
            return nil
        }
    }
}



