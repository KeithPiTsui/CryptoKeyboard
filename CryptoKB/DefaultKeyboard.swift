
//
//  KeyboardLayoutHelper.swift
//  CryptoKeyboard
//
//  Created by Pi on 11/12/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

fileprivate var numericKeyRepresentations:
    [(type: Key.KeyType, meaning: String?, inscript: String?, mode: Int?, column: Int, row: Int, page: Int)]? = [
        (.number,"1", nil,    nil,    0, 0 ,0),
        (.number,"2", nil,    nil,    1, 0 ,0),
        (.number,"3", nil,    nil,    2, 0 ,0),
        (.number,"4", nil,    nil,    0, 1 ,0),
        (.number,"5", nil,    nil,    1, 1 ,0),
        (.number,"6", nil,    nil,    2, 1 ,0),
        (.number,"7", nil,    nil,    0, 2 ,0),
        (.number,"8", nil,    nil,    1, 2 ,0),
        (.number,"9", nil,    nil,    2, 2 ,0),
        (.number,"0", nil,    nil,    0, 3 ,0),
        (.backspace,    nil,    nil,    nil,    1, 3 ,0)]

fileprivate var alphabetKeyRepresentations:
    [(type: Key.KeyType, meaning: String?, inscript: String?, mode: Int?, column: Int, row: Int, page: Int)]? = [
        (.alphabet,    "Q",    nil,    nil,    0, 0, 0),
        (.alphabet,    "W",    nil,    nil,    1, 0, 0),
        (.alphabet,    "E",    nil,    nil,    2, 0, 0),
        (.alphabet,    "R",    nil,    nil,    3, 0, 0),
        (.alphabet,    "T",    nil,    nil,    4, 0 ,0),
        (.alphabet,    "Y",    nil,    nil,    5, 0 ,0),
        (.alphabet,    "U",    nil,    nil,    6, 0 ,0),
        (.alphabet,    "I",    nil,    nil,    7, 0 ,0),
        (.alphabet,    "O",    nil,    nil,    8, 0 ,0),
        (.alphabet,    "P",    nil,    nil,    9, 0 ,0),
        
        (.alphabet,    "A",    nil,    nil,    0, 1 ,0),
        (.alphabet,    "S",    nil,    nil,    1, 1 ,0),
        (.alphabet,    "D",    nil,    nil,    2, 1 ,0),
        (.alphabet,    "F",    nil,    nil,    3, 1 ,0),
        (.alphabet,    "G",    nil,    nil,    4, 1 ,0),
        (.alphabet,    "H",    nil,    nil,    5, 1 ,0),
        (.alphabet,    "J",    nil,    nil,    6, 1 ,0),
        (.alphabet,    "K",    nil,    nil,    7, 1 ,0),
        (.alphabet,    "L",    nil,    nil,    8, 1 ,0),
        
        (.shift,        nil,    nil,    nil,    0, 2 ,0),
        (.alphabet,    "Z",    nil,    nil,    1, 2 ,0),
        (.alphabet,    "X",    nil,    nil,    2, 2 ,0),
        (.alphabet,    "C",    nil,    nil,    3, 2 ,0),
        (.alphabet,    "V",    nil,    nil,    4, 2 ,0),
        (.alphabet,    "B",    nil,    nil,    5, 2 ,0),
        (.alphabet,    "N",    nil,    nil,    6, 2 ,0),
        (.alphabet,    "M",    nil,    nil,    7, 2 ,0),
        (.backspace,    nil,    nil,    nil,    8, 2 ,0)]

fileprivate var keyRepresentations:
[(type: Key.KeyType, meaning: String?, inscript: String?, mode: Int?, column: Int, row: Int, page: Int)]? = [
(.alphabet,    "Q",    nil,    nil,    0, 0, 0),
(.alphabet,    "W",    nil,    nil,    1, 0, 0),
(.alphabet,    "E",    nil,    nil,    2, 0, 0),
(.alphabet,    "R",    nil,    nil,    3, 0, 0),
(.alphabet,    "T",    nil,    nil,    4, 0 ,0),
(.alphabet,    "Y",    nil,    nil,    5, 0 ,0),
(.alphabet,    "U",    nil,    nil,    6, 0 ,0),
(.alphabet,    "I",    nil,    nil,    7, 0 ,0),
(.alphabet,    "O",    nil,    nil,    8, 0 ,0),
(.alphabet,    "P",    nil,    nil,    9, 0 ,0),

(.alphabet,    "A",    nil,    nil,    0, 1 ,0),
(.alphabet,    "S",    nil,    nil,    1, 1 ,0),
(.alphabet,    "D",    nil,    nil,    2, 1 ,0),
(.alphabet,    "F",    nil,    nil,    3, 1 ,0),
(.alphabet,    "G",    nil,    nil,    4, 1 ,0),
(.alphabet,    "H",    nil,    nil,    5, 1 ,0),
(.alphabet,    "J",    nil,    nil,    6, 1 ,0),
(.alphabet,    "K",    nil,    nil,    7, 1 ,0),
(.alphabet,    "L",    nil,    nil,    8, 1 ,0),

(.shift,        nil,    nil,    nil,    0, 2 ,0),
(.alphabet,    "Z",    nil,    nil,    1, 2 ,0),
(.alphabet,    "X",    nil,    nil,    2, 2 ,0),
(.alphabet,    "C",    nil,    nil,    3, 2 ,0),
(.alphabet,    "V",    nil,    nil,    4, 2 ,0),
(.alphabet,    "B",    nil,    nil,    5, 2 ,0),
(.alphabet,    "N",    nil,    nil,    6, 2 ,0),
(.alphabet,    "M",    nil,    nil,    7, 2 ,0),
(.backspace,    nil,    nil,    nil,    8, 2 ,0),

(.modeChange,   nil,  "123",    1,      0, 3 ,0),
(.keyboardChange, nil,  nil,    nil,    1, 3 ,0),
(.settings,     nil,    nil,    nil,    2, 3 ,0),
(.space,        " ",    nil,    nil,    3, 3 ,0),
(.return,      "\n","Ret",   nil,    4, 3 ,0),

(.number,"1", nil,    nil,    0, 0 ,1),
(.number,"2", nil,    nil,    1, 0 ,1),
(.number,"3", nil,    nil,    2, 0 ,1),
(.number,"4", nil,    nil,    3, 0 ,1),
(.number,"5", nil,    nil,    4, 0 ,1),
(.number,"6", nil,    nil,    5, 0 ,1),
(.number,"7", nil,    nil,    6, 0 ,1),
(.number,"8", nil,    nil,    7, 0 ,1),
(.number,"9", nil,    nil,    8, 0 ,1),
(.number,"0", nil,    nil,    9, 0 ,1),

(.symbol,"-", nil,    nil,    0, 1 ,1),
(.symbol,"/", nil,    nil,    1, 1 ,1),
(.punctuation,":", nil,    nil,    2, 1 ,1),
(.punctuation,";", nil,    nil,    3, 1 ,1),
(.symbol,"(", nil,    nil,    4, 1 ,1),
(.symbol,")", nil,    nil,    5, 1 ,1),
(.symbol,"$", nil,    nil,    6, 1 ,1),
(.symbol,"&", nil,    nil,    7, 1 ,1),
(.symbol,"@", nil,    nil,    8, 1 ,1),
(.symbol,"\"",nil,    nil,    9, 1 ,1),

(.modeChange,   nil,  "#+=",    2,      0, 2 ,1),
(.punctuation,".", nil,    nil,    1, 2 ,1),
(.punctuation,",", nil,    nil,    2, 2 ,1),
(.punctuation,"?", nil,    nil,    3, 2 ,1),
(.punctuation,"!", nil,    nil,    4, 2 ,1),
(.punctuation,"'", nil,    nil,    5, 2 ,1),
(.backspace,       nil, nil,    nil,    6, 2 ,1),

(.modeChange,   nil,  "ABC",    0,      0, 3 ,1),
(.keyboardChange,   nil,nil,    nil,    1, 3 ,1),
(.settings,         nil,nil,    nil,    2, 3 ,1),
(.space,        " ",    nil,    nil,    3, 3 ,1),
(.return,      "\n","Return",   nil,    4, 3 ,1),

(.symbol,"[", nil,    nil,    0, 0 ,2),
(.symbol,"]", nil,    nil,    1, 0 ,2),
(.symbol,"{", nil,    nil,    2, 0 ,2),
(.symbol,"}", nil,    nil,    3, 0 ,2),
(.symbol,"#", nil,    nil,    4, 0 ,2),
(.symbol,"%", nil,    nil,    5, 0 ,2),
(.symbol,"^", nil,    nil,    6, 0 ,2),
(.symbol,"*", nil,    nil,    7, 0 ,2),
(.symbol,"+", nil,    nil,    8, 0 ,2),
(.symbol,"=", nil,    nil,    9, 0 ,2),

(.symbol,"_", nil,    nil,    0, 1 ,2),
(.symbol,"\\",nil,    nil,    1, 1 ,2),
(.symbol,"|", nil,    nil,    2, 1 ,2),
(.symbol,"~", nil,    nil,    3, 1 ,2),
(.symbol,"<", nil,    nil,    4, 1 ,2),
(.symbol,">", nil,    nil,    5, 1 ,2),
(.symbol,"€", nil,    nil,    6, 1 ,2),
(.symbol,"£", nil,    nil,    7, 1 ,2),
(.symbol,"¥", nil,    nil,    8, 1 ,2),
(.symbol,"•", nil,    nil,    9, 1 ,2),

(.modeChange,   nil,  "123",    1,      0, 2 ,2),
(.punctuation,".", nil,    nil,    1, 2 ,2),
(.punctuation,",", nil,    nil,    2, 2 ,2),
(.punctuation,"?", nil,    nil,    3, 2 ,2),
(.punctuation,"!", nil,    nil,    4, 2 ,2),
(.punctuation,"'", nil,    nil,    5, 2 ,2),
(.backspace,       nil, nil,    nil,    6, 2 ,2),

(.modeChange,   nil,  "ABC",    0,      0, 3 ,2),
(.keyboardChange,   nil,nil,    nil,    1, 3 ,2),
(.settings,         nil,nil,    nil,    2, 3 ,2),
(.space,        " ",    nil,    nil,    3, 3 ,2),
(.return,      "\n","Return",   nil,    4, 3 ,2),
]


extension Keyboard {
    static let defaultKeyboard: Keyboard =  {
        assert(keyRepresentations != nil, "Key Representations must not be nil")
        var defaultKeyboard = Keyboard(columns: 10, rows: 4, pages: 3)
        for keyRep in keyRepresentations! {
            defaultKeyboard.keys[keyRep.page][keyRep.row][keyRep.column]
                = Key(type: keyRep.type, meaning: keyRep.meaning, inscript: keyRep.inscript, mode: keyRep.mode)
        }
        keyRepresentations = nil
        return defaultKeyboard
    }()
    
    static let alphabetKeyboard: Keyboard = {
        assert(alphabetKeyRepresentations != nil, "Key Representations must not be nil")
        var defaultKeyboard = Keyboard(columns: 10, rows: 3, pages: 1)
        for keyRep in alphabetKeyRepresentations! {
            defaultKeyboard.keys[keyRep.page][keyRep.row][keyRep.column]
                = Key(type: keyRep.type, meaning: keyRep.meaning, inscript: keyRep.inscript, mode: keyRep.mode)
        }
        alphabetKeyRepresentations = nil
        return defaultKeyboard
    }()
    
    static let numericKeyboard: Keyboard = {
        assert(numericKeyRepresentations != nil, "Key Representations must not be nil")
        var defaultKeyboard = Keyboard(columns: 3, rows: 4, pages: 1)
        for keyRep in numericKeyRepresentations! {
            defaultKeyboard.keys[keyRep.page][keyRep.row][keyRep.column]
                = Key(type: keyRep.type, meaning: keyRep.meaning, inscript: keyRep.inscript, mode: keyRep.mode)
        }
        numericKeyRepresentations = nil
        return defaultKeyboard
    }()

}



enum Primitive {
    case ellipse
    case rectangle
    case text(String)
    case key(Key)
}

indirect enum Diagram {
    case primitive(CGSize, Primitive)
    case beside(Diagram, CGFloat, Diagram)
    case below(Diagram, CGFloat, Diagram)
    case attributed(Attribute, Diagram)
    case align(CGPoint, Diagram)
}

enum Attribute {
    case fillColor(UIColor)
}

extension Diagram {
    var size: CGSize {
        switch self {
        case .primitive(let size, _):
            return size
        case .attributed(_, let x):
            return x.size
        case let .beside(l, gap, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: sizeL.width + sizeR.width + gap, height: max(sizeL.height, sizeR.height))
        case let .below(l, gap, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: max(sizeL.width, sizeR.width), height: sizeL.height + sizeR.height + gap)
        case .align(_, let r):
            return r.size
        }
    }
    init() { self = rect(width: 0, height: 0) }
    
    func filled(_ color: UIColor) -> Diagram {
        return .attributed(.fillColor(color), self)
    }
    
    func aligned(to position: CGPoint) -> Diagram {
        return .align(position, self)
    }
    func image(of size: CGSize) -> UIImage {
        let render = UIGraphicsImageRenderer(size: size)
        return render.image {$0.cgContext.draw(self, in: CGRect(origin: .zero, size: size))}
    }
    
}

extension CGSize {
    func fit(into rect: CGRect, alignment: CGPoint) -> CGRect {
        let scale = min(rect.width / width, rect.height / height)
        let targetSize = scale * self
        let spacerSize = alignment.size * (rect.size - targetSize)
        return CGRect(origin: rect.origin + spacerSize.point, size: targetSize)
    }
    
    static func * (l: CGFloat, r: CGSize) -> CGSize {
        return CGSize(width: l * r.width, height: l * r.height)
    }
    
    static func * (l: CGSize, r: CGSize) -> CGSize {
        return CGSize(width: l.width * r.width, height: l.height * r.height)
    }
    
    static func - (l: CGSize, r: CGSize) -> CGSize {
        return CGSize(width: l.width - r.width, height: l.height - r.height)
    }
    
    var point: CGPoint { return CGPoint(x: self.width, y: self.height) }
}

extension CGPoint {
    var size: CGSize { return CGSize(width: x, height: y) }
    static let topCenter = CGPoint(x: 0.5, y: 0)
    static let topLeft = CGPoint(x: 0, y: 0)
    static let topRight = CGPoint(x: 1, y: 0)
    
    static let center = CGPoint(x: 0.5, y: 0.5)
    static let centerLeft = CGPoint(x: 0, y: 0.5)
    static let centerRight = CGPoint(x: 1, y: 0.5)
    
    static let bottomLeft = CGPoint(x: 0, y: 1)
    static let bottomCenter = CGPoint(x: 0.5, y: 1)
    static let bottomRight = CGPoint(x: 1, y: 1)
}

func + (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x:l.x + r.x, y: l.y + r.y)
}


extension CGRect {
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width: height
        return divided(atDistance: length * ratio, from: edge)
    }
    
    func splitThree(firstFraction: CGFloat, lastFraction: CGFloat, isHorizontal: Bool) ->(CGRect, CGRect) {
        if isHorizontal {
            let w1 = self.width * firstFraction
            let c1 = CGRect(x: self.origin.x, y: 0, width: w1, height: self.height)
            let w2 = self.width * lastFraction
            let c2 = CGRect(x: self.origin.x + self.width - w2, y: 0, width: w2, height: self.height)
            return (c1, c2)
        } else {
            let h1 = self.height * firstFraction
            let c1 = CGRect(x: 0, y: self.origin.y, width: self.width, height: h1)
            let h2 = self.height * lastFraction
            let c2 = CGRect(x: 0, y: self.origin.y + self.height - h2, width: self.width, height: h2)
            return (c1, c2)
        }
    }
    
}

extension CGRectEdge {
    var isHorizontal: Bool { return self == .maxXEdge || self == .minXEdge}
}



extension KeyboardView {
    func layout(_ primitive: Primitive, in frame: CGRect) {
        if case let .key(k) = primitive {
            let kv = KeyboardViewItem(frame: frame, key: k)
            self.addSubview(kv)
        }
    }
    
    func layout(_ diagram: Diagram, in bounds: CGRect) {
        switch diagram {
        case let .primitive(size, primitive):
            let bounds = size.fit(into: bounds, alignment: .center)
            layout(primitive, in: bounds)
            
        case .align(let alignment, let diagram):
            let bounds = diagram.size.fit(into: bounds, alignment: alignment)
            layout(diagram, in: bounds)
            
        case let .beside(l, _, r):
            let (lBounds, rBounds) = bounds.splitThree(firstFraction: l.size.width / diagram.size.width,
                                                       lastFraction: r.size.width / diagram.size.width,
                                                       isHorizontal: true)
            layout(l, in: lBounds)
            layout(r, in: rBounds)
            
        case .below(let top, _, let bottom):
            let (tBounds, bBounds) = bounds.splitThree(firstFraction: top.size.height / diagram.size.height,
                                                       lastFraction: bottom.size.height / diagram.size.height,
                                                       isHorizontal: false)
            layout(top, in: tBounds)
            layout(bottom, in: bBounds)
            
        case let .attributed(_, diagram):
            layout(diagram, in: bounds)
        }
    }
}


extension CGContext {
    func draw(_ primitive: Primitive, in frame: CGRect) {
        switch primitive {
        case .rectangle:
            fill(frame)
        case .ellipse:
            fillEllipse(in: frame)
        case .text(let text):
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSFontAttributeName: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: frame)
        default: break
        }
    }
    
    func draw(_ diagram: Diagram, in bounds: CGRect) {
        switch diagram {
        case let .primitive(size, primitive):
            let bounds = size.fit(into: bounds, alignment: .center)
            draw(primitive, in: bounds)
            
        case .align(let alignment, let diagram):
            let bounds = diagram.size.fit(into: bounds, alignment: alignment)
            draw(diagram, in: bounds)
            
        case let .beside(l, _, r):
            let (lBounds, rBounds) = bounds.splitThree(firstFraction: l.size.width / diagram.size.width,
                                                       lastFraction: r.size.width / diagram.size.width,
                                                       isHorizontal: true)
            draw(l, in: lBounds)
            draw(r, in: rBounds)
            
        case .below(let top, _, let bottom):
            let (tBounds, bBounds) = bounds.splitThree(firstFraction: top.size.height / diagram.size.height,
                                                       lastFraction: bottom.size.height / diagram.size.height,
                                                       isHorizontal: false)
            draw(top, in: tBounds)
            draw(bottom, in: bBounds)
            
        case let .attributed(.fillColor(color), diagram):
            saveGState()
            color.set()
            draw(diagram, in: bounds)
            restoreGState()
        }
    }
}

func rect(width: CGFloat, height: CGFloat) -> Diagram {
    return .primitive(CGSize(width: width, height: height), .rectangle)
}

func circle(diameter: CGFloat) -> Diagram {
    return .primitive(CGSize(width: diameter, height: diameter), .ellipse)
}

func text(_ theText: String, width: CGFloat, height: CGFloat) -> Diagram {
    return .primitive(CGSize(width: width, height: height), .text(theText))
}

func square(side: CGFloat) -> Diagram {
    return rect(width: side, height: side)
}

precedencegroup HorizontalCombination {
    higherThan: VerticalCombination
    associativity: left
}

precedencegroup VerticalCombination {
    associativity: left
}

infix operator ||| : HorizontalCombination
func ||| (l: Diagram, r: Diagram) -> Diagram {
    return .beside(l, 0, r)
}

func ||| (l: Diagram, g: CGFloat) -> Diagram {
    return .beside(l, g, Diagram())
}

func ||| (g: CGFloat, r: Diagram) -> Diagram {
    return .beside(Diagram(), g, r)
}


infix operator --- : VerticalCombination
func --- (l: Diagram, r: Diagram) -> Diagram {
    return .below(l, 0, r)
}

extension Sequence where Iterator.Element == Diagram {
    var hcat: Diagram { return reduce(Diagram(), |||) }
}















