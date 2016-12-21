//
//  CMarkWrapper.swift
//  CryptoKeyboard
//
//  Created by Pi on 21/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

func markdownToHTML(input: String) -> String {
    let outString = cmark_markdown_to_html(input, input.utf8.count, 0)!
    return String(cString: outString)
}





