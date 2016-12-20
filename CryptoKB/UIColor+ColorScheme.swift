//
//  GlobalColors.swift
//  TastyImitationKeyboard
//
//  Created by Pi on 28/11/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

extension UIColor {
    static let keyboardViewBackgroundColor = UIColor(25, 9, 43)
    static let keyboardViewItemBackgroundColor = UIColor.clear
    static let keyboardViewItemInscriptColor = UIColor.white
    static let keyboardViewItemHighlightedBackgroundColor = UIColor(211,30,79)
    static let topBarBackgroundColor = UIColor(27,18,46)
    static let topBarInscriptColor = UIColor(152,157,170)
    static let globalDrawingColor = UIColor(204,208,202)
    static let spaceColor = UIColor(204,208,202,0.4)
    static let shiftIconDrawingColor = UIColor(204,208,202)
    static let shiftIconHighlightDrawingColor = UIColor(207,59,124)
    static let backspaceFillColor = UIColor(204,208,202)
    static let backspaceInscriptColor = UIColor(25, 9, 43)
    static let barCheckedSymbolColor = UIColor(122,179,170)
    
    convenience init(_ r:CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) {
         self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

struct KeyboardAppearanceScheme {
    /*Family:Chalkboard SE
     Font:ChalkboardSE-Bold
     Family:Chalkboard SE
     Font:ChalkboardSE-Light
     Family:Chalkboard SE
     Font:ChalkboardSE-Regular*/
    static let keyboardViewItemInscriptFont = UIFont(name: "ChalkboardSE-Light", size: 25)!
    static let keyboardViewItemInscriptFontSmall = UIFont(name: "ChalkboardSE-Light", size: 18)!
    static let topBarInscriptFont = UIFont(name: "ChalkboardSE-Light", size: 18)!
    static let topBarTagInscriptFont = UIFont(name: "ChalkboardSE-Light", size: 12)!
}

extension UIFont {
    static let translatorOriginalTextFont = UIFont(name: "ChalkboardSE-Light", size: 30)!
    static let keyboardViewItemInscriptFont = UIFont(name: "ChalkboardSE-Light", size: 25)!
    static let keyboardViewItemInscriptFontSmall = UIFont(name: "ChalkboardSE-Light", size: 18)!
    static let topBarInscriptFont = UIFont(name: "ChalkboardSE-Light", size: 18)!
    static let topBarTagInscriptFont = UIFont(name: "ChalkboardSE-Light", size: 12)!
}


struct KeyboardConstants {
    
}

