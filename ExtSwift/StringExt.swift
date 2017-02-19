//
//  StringExt.swift
//  ExtSwift
//
//  Created by Pi on 19/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

extension String {
    public var chars: [String] {
        return self.characters.reduce([]) {(initializer:[String], element: Character) -> [String] in
            var strings = initializer
            strings.append("\(element)")
            return strings
        }
    }
}
