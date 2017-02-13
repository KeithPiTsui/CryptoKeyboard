//
//  KeyboardDiagram.swift
//  CryptoKeyboard
//
//  Created by Pi on 13/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit

enum Primitive {
    case empty
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
    init() { self = .primitive(CGSize(width: 0, height: 0), .empty) }
    
    func filled(_ color: UIColor) -> Diagram {
        return .attributed(.fillColor(color), self)
    }
    
    func aligned(to position: CGPoint) -> Diagram {
        return .align(position, self)
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
            let c1 = CGRect(x: self.origin.x, y: self.origin.y, width: w1, height: self.height)
            let w2 = self.width * lastFraction
            let c2 = CGRect(x: self.origin.x + self.width - w2, y: self.origin.y, width: w2, height: self.height)
            return (c1, c2)
        } else {
            let h1 = self.height * firstFraction
            let c1 = CGRect(x: self.origin.x, y: self.origin.y, width: self.width, height: h1)
            let h2 = self.height * lastFraction
            let c2 = CGRect(x: self.origin.x, y: self.origin.y + self.height - h2, width: self.width, height: h2)
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

func --- (g: CGFloat, r: Diagram) -> Diagram {
    return .below(Diagram(), g, r)
}

func --- (l: Diagram, g: CGFloat) -> Diagram {
    return .below(l, g, Diagram())
}



extension Sequence where Iterator.Element == Diagram {
    var hcat: Diagram { return reduce(Diagram(), |||) }
}


extension Diagram : ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        let values = value.components(separatedBy: "><")
        if values.count == 1 {
            self = .primitive(CGSize(width: 1, height: 1), .key(values[0].key))
        } else if values.count == 2 {
            guard let w = Double(values[1]) else { fatalError("keyboard layout syntax error") }
            self = .primitive(CGSize(width: w, height: 1), .key(values[0].key))
        } else if values.count == 3 {
            guard let w = Double(values[1]) else { fatalError("keyboard layout syntax error") }
            guard let h = Double(values[2]) else { fatalError("keyboard layout syntax error") }
            self = .primitive(CGSize(width: w, height: h), .key(values[0].key))
        } else {
            fatalError("keyboard layout syntax error")
        }
    }
    
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }

    init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}


















