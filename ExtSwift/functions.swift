//
//  functions.swift
//  ExtSwift
//
//  Created by Pi on 19/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit


public func dictionaryOfNames(_ arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerated() {
        d["v\(ix+1)"] = v
    }
    return d
}

public func delay(_ seconds:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + seconds
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
