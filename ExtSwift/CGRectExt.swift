//
//  CGRectExt.swift
//  ExtSwift
//
//  Created by Pi on 19/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit

extension CGRect {
    public init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
    public var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

extension CGRect {
    public func splitThree(firstFraction: CGFloat, lastFraction: CGFloat, isHorizontal: Bool) ->(CGRect, CGRect) {
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
