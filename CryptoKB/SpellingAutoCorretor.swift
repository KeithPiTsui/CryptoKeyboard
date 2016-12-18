//
//  File.swift
//  CryptoKeyboard
//
//  Created by Pi on 13/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import Foundation

// even though infix ..< already exists, we need to declare it
// two more times for the prefix and postfix form
postfix operator ..<
prefix operator ..<


struct RangeStart<I: Comparable> { let start: I }
struct RangeEnd<I: Comparable> { let end: I }

postfix func ..< <I: Comparable> (lhs: I) -> RangeStart<I> { return RangeStart(start: lhs) }

prefix func ..< <I: Comparable> (rhs: I) -> RangeEnd<I> { return RangeEnd(end: rhs) }

extension String {
    
    subscript(r: RangeStart<String.UnicodeScalarView.Index>) -> String.UnicodeScalarView {
        return unicodeScalars[r.start..<unicodeScalars.endIndex] }
    
    subscript(r: RangeEnd<String.UnicodeScalarView.Index>) -> String.UnicodeScalarView {
        return unicodeScalars[unicodeScalars.startIndex..<r.end]}
    
    var indices:[String.UnicodeScalarView.Index] {
        var idc: [String.UnicodeScalarView.Index] = []
        idc.reserveCapacity(unicodeScalars.count)
        var idx = unicodeScalars.startIndex
        while idx != unicodeScalars.endIndex {
            idc.append(idx)
            idx = unicodeScalars.index(after: idx)
        }
        return idc
    }
}

final class SpellChecker {
    
    static let defaultChecker: SpellChecker = {return SpellChecker(contentsOfFile: "words.txt")!}()
    
    /// Using Set for vocabulary container is due to its O(1) retrival
    var vocabulary: Set<String>
    
    init?(contentsOfFile file: String) {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else {return nil}
        guard let text = (try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8))?.lowercased() else {return nil}
        let words = text.unicodeScalars.split { !("a"..."z").contains($0) }.map { String($0) }
        vocabulary = Set(words)
    }

    func correct(word: String) -> Set<String> {
        
        if let candidates = SpellChecker.inVocabulary(words: [word], vocabulary: vocabulary) {
            return candidates
        }
        
        let possibleWords = SpellChecker.possibles(word: word)
        if let candidates = SpellChecker.inVocabulary(words: possibleWords, vocabulary: vocabulary) {
            return candidates
        }
        
        var candidates: Set<String> = []
        for possibleWord in possibleWords {
            if let k = SpellChecker.inVocabulary(words: SpellChecker.possibles(word: possibleWord), vocabulary: vocabulary) {
                candidates.formUnion(k)
            }
        }
        if candidates.isEmpty { return [word] }
        return candidates
    }
    
    private static func inVocabulary<S: Sequence>(words: S, vocabulary: Set<String>) -> Set<String>? where S.Iterator.Element == String {
        let s = Set( words.filter{ vocabulary.contains($0) } )
        return s.isEmpty ? nil : s
    }
    
    private static let alphabet = "abcdefghijklmnopqrstuvwxyz".unicodeScalars
    
    /// Given a word, produce a set of possible alternatives with
    /// letters transposed, deleted, replaced or rogue characters inserted
    private static func possibles(word: String) -> Set<String> {
        if word.isEmpty { return [] }
        
        /// Hello ->("", Hello) (H, ello), (He, llo), (Hel, lo), (Hell,o), (Hello, "")
        // using unicode scalar will optimize this line from O(n^2) -> O(n)
        let splits = word.indices.map { (word[..<$0], word[$0..<])}
        
        // Hello -> ello, hllo, helo, helo, hell, hello
        let deletes = splits.map { $0.0 + $0.1.dropFirst() }
        
        // (H, ello) -> Hlelo
        let transposes: [String.UnicodeScalarView] = splits.map { left, right in
            var left = left
            guard right.count >= 2 else {return String.UnicodeScalarView()}
            let second = right.index(after: right.startIndex)
            left.append(right[second])
            left.append(right[right.startIndex])
            left.append(contentsOf: right.suffix(from: right.index(after: second)))
            return left
            
            }.filter { !$0.isEmpty }
        
        
        
        let replaces = splits.flatMap { (left: String.UnicodeScalarView, right: String.UnicodeScalarView) -> [String.UnicodeScalarView] in
            // (he, llo) becomes healo, heblo, heclo etc
            return alphabet.map {
                var left = left
                left.append($0)
                left.append(contentsOf: right.dropFirst())
                return left
            }
        }
        
        let inserts = splits.flatMap { (left: String.UnicodeScalarView, right: String.UnicodeScalarView) -> [String.UnicodeScalarView]  in
            // (he, llo) becomes heallo, hebllo, hecllo etc
            return alphabet.map {
                var left = left
                left.append($0)
                left.append(contentsOf: right)
                return left
            }
        }
        let combined = (deletes + transposes + replaces + inserts).map{String($0)}
        
        return Set(combined)
    }
}
































