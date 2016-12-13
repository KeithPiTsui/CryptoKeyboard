//
//  File.swift
//  CryptoKeyboard
//
//  Created by Pi on 13/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation


//var word = "Hello"
//
//// hello becomes (,hello), (h,ello), (he,llo) etc.
//let splits = word.indices.map { (word[..<$0], word[$0..<])}
//
//// (h, ello) becomes hllo
//let deletes = splits.map { $0.0 + $0.1.dropFirst() }
//
//
//// (h, ello) becomes hlelo
//let transposes: [String] = splits.map { left, right in
//                                        if let fst = right.first {
//                                            let drop1 = right.dropFirst()
//                                            if let snd = drop1.first {
//                                                let drop2 = drop1.dropFirst()
//                                                return "\(left)\(snd)\(fst)\(drop2)"
//                                            }
//                                        }
//                                    return ""}.filter {!$0.isEmpty }
//
//let alphabet = "abcdefghijklmnopqrstuvwxyz"
//
//let replaces = splits.flatMap { left, right in
//    // (he, llo) becomes healo, heblo, heclo etc
//    alphabet.characters.map { "\(left)\($0)\(right.dropFirst())" }
//}
//
//let inserts = splits.flatMap { left, right in
//    // (he, llo) becomes heallo, hebllo, hecllo etc
//    alphabet.characters.map { "\(left)\($0)\(right)" }
//}

// even though infix ..< already exists, we need to declare it
// two more times for the prefix and postfix form
postfix operator ..<
prefix operator ..<

// then, declare a couple of simple custom types that indicate one-sided ranges:
struct RangeStart<I: Comparable> { let start: I }
struct RangeEnd<I: Comparable> { let end: I }

// and define ..< to return them
postfix func ..<<I: Comparable>(lhs: I) -> RangeStart<I>
{ return RangeStart(start: lhs) }

prefix func ..<<I: Comparable>(rhs: I) -> RangeEnd<I>
{ return RangeEnd(end: rhs) }

// finally, extend String to have a slicing subscript for these types:
extension String {
    subscript(r: RangeStart<String.Index>) -> String {
        return self[r.start..<self.endIndex]
    }
    subscript(r: RangeEnd<String.Index>) -> String {
        return self[self.startIndex..<r.end]
    }
    
    var indices:[String.Index] {
        var idc: [String.Index] = []
        var idx = startIndex
        while idx != endIndex {
            idc.append(idx)
            idx = index(after: idx)
        }
        return idc
    }
    
    func dropFirst() -> String {
        if isEmpty {return self}
        var retStr = self
        retStr.remove(at: startIndex)
        return retStr
    }
    
    var first: String? {
        if isEmpty {return nil}
        return substring(to: index(after: startIndex))
    }
}

/// Given a word, produce a set of possible alternatives with
/// letters transposed, deleted, replaced or rogue characters inserted
fileprivate func edits(word: String) -> Set<String> {
    if word.isEmpty { return [] }
    
    let splits = word.indices.map {
        (word[word.startIndex..<$0], word[$0..<word.endIndex])
    }
    
    let deletes = splits.map { $0.0 + $0.1.dropFirst() }
    
    let transposes: [String] = splits.map { left, right in
        if let fst = right.first {
            let drop1 = right.dropFirst()
            if let snd = drop1.first {
                let drop2 = drop1.dropFirst()
                return "\(left)\(snd)\(fst)\(drop2)"
            }
        }
        return ""
        }.filter { !$0.isEmpty }
    
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    
    let replaces = splits.flatMap { left, right in
        // (he, llo) becomes healo, heblo, heclo etc
        alphabet.characters.map { "\(left)\($0)\(right.dropFirst())" }
    }
    
    let inserts = splits.flatMap { left, right in
        // (he, llo) becomes heallo, hebllo, hecllo etc
        alphabet.characters.map { "\(left)\($0)\(right)" }
    }
    
    return Set(deletes + transposes + replaces + inserts)
}

struct SpellChecker {
    var knownWords: [String:Int] = [:]
    
    mutating func train(word: String) {
        knownWords[word] = knownWords[word]?.advanced(by: 1) ?? 1
    }
    
    init?(contentsOfFile file: String) {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else {return nil}
        guard let text = (try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8))?.lowercased() else {return nil}
        let words = text.unicodeScalars.split { !("a"..."z").contains($0) }.map { String($0) }
        for word in words { self.train(word: word) }
    }

    func known<S: Sequence>(words: S) -> Set<String>? where S.Iterator.Element == String {
        let s = Set(words.filter{ self.knownWords.index(forKey: $0) != nil })
        return s.isEmpty ? nil : s
    }

    func knownEdits2(word: String) -> Set<String>? {
        var known_edits: Set<String> = []
        for edit in edits(word: word) {
            if let k = known(words: edits(word: edit)) {
                known_edits.formUnion(k)
            }
        }
        return known_edits.isEmpty ? nil : known_edits
    }
    
    func correct(word: String) -> [String] {
        let candidates = known(words: [word]) ?? known(words: edits(word: word)) ?? knownEdits2(word: word)
        if candidates != nil {
            return candidates!.reduce([]) {
                var strs = $0.0
                strs.append($0.1)
                return strs
            }
        } else {
            return [word]
        }
    }
}
































