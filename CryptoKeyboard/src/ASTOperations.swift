//
//  ASTOperations.swift
//  CommonMark
//
//  Created by Chris Eidhof on 23/05/15.
//  Copyright (c) 2015 Unsigned Integer. All rights reserved.
//

import Foundation

func flatten<A>(_ x: [[A]]) -> [A] {
    return x.flatMap { $0 }
}

/// Apply a transformation to each block-level element in a Markdown document.
/// Performs a deep traversal of the element tree.
///
/// - parameter elements: The Markdown document you want to transform, 
///   represented as an array of block-level elements.
/// - parameter f: The transformation function that will be recursively applied
///   to each block-level element in `elements`.
///
///   The function returns an array of elements, which allows you to transform
///   one element into several (or none). Return an array containing only the
///   unchanged element to not transform that element at all. Return an empty
///   array to delete an element from the result.
/// - returns: A Markdown document containing the results of the transformation,
///   represented as an array of block-level elements.
public func deepApply(elements: [Block],  _ f: @escaping (Block) throws -> [Block]) rethrows -> [Block] {
    return try elements.flatMap {
        try deepApply(f: f, element: $0)
        //try deepApply(f)(element: $0)
    }
}

/// Apply a transformation to each inline element in a Markdown document.
/// Performs a deep traversal of the element tree.
///
/// - parameter elements: The Markdown document you want to transform,
///   represented as an array of block-level elements.
/// - parameter f: The transformation function that will be recursively applied
///   to each inline element in `elements`.
///
///   The function returns an array of elements, which allows you to transform
///   one element into several (or none). Return an array containing only the
///   unchanged element to not transform that element at all. Return an empty 
///   array to delete an element from the result.
/// - returns: A Markdown document containing the results of the transformation,
///   represented as an array of block-level elements.
public func deepApply(elements: [Block],  _ f: @escaping (InlineElement) throws -> [InlineElement]) rethrows -> [Block] {
    return try elements.flatMap {
        //try deepApply(f)(element: $0)
        try deepApply(f: f, element: $0)
    }
}

private func deepApply(f: @escaping (Block) throws -> [Block], element: Block) rethrows -> [Block] {
    let recurse: (Block) throws -> [Block] =  {try deepApply(f: f, element: $0)}  //deepApply(f)
   switch element {
   case let .list(items, type):
     let mapped = Block.list(items: try items.map { try $0.flatMap(recurse) }, type: type)
     return try f(mapped)
   case .blockQuote(let items):
    return try f(Block.blockQuote(items: try items.flatMap { try recurse($0) }))
   default:
     return try f(element)
   }
}

private func deepApply(f: @escaping (InlineElement) throws -> [InlineElement], element: Block) rethrows -> [Block] {
    let recurse: (Block) throws -> [Block] = {try deepApply(f: f, element: $0)} //deepApply(f)
    let applyInline: (InlineElement) throws -> [InlineElement] = {try deepApply(f: f, element: $0)}//deepApply(f)
    switch element {
    case .paragraph(let children):
        return [Block.paragraph(text: try children.flatMap { try applyInline($0) })]
    case let .list(items, type):
        return [Block.list(items: try items.map { try $0.flatMap { try recurse($0) } }, type: type)]
    case .blockQuote(let items):
        return [Block.blockQuote(items: try items.flatMap { try recurse($0) })]
    case let .header(text, level):
        return [Block.header(text: try text.flatMap { try applyInline($0) }, level: level)]
    default:
        return [element]
    }
}

private func deepApply(f: @escaping (InlineElement) throws -> [InlineElement], element: InlineElement) rethrows -> [InlineElement] {
    let recurse: (InlineElement) throws -> [InlineElement] = {try deepApply(f: f, element: $0)} //deepApply(f)
    switch element {
    case .emphasis(let children):
        return try f(InlineElement.emphasis(children: try children.flatMap { try recurse($0) }))
    case .strong(let children):
        return try f(InlineElement.strong(children: try children.flatMap { try recurse($0) }))
    case let .link(children, title, url):
        return try f(InlineElement.link(children: try children.flatMap { try recurse($0) }, title: title, url: url))
    case let .image(children, title, url):
        return try f(InlineElement.image(children: try children.flatMap  { try recurse($0) }, title: title, url: url))
    default:
        return try f(element)
    }
}


/// Performs a deep 'flatMap' operation over all _block-level elements_ in a
/// Markdown document. Performs a deep traversal over all block-level elements
/// in the element tree, applies `f` to each element, and returns the flattened
/// results.
///
/// Use this function to extract data from a Markdown document. E.g. you could
/// extract the texts and levels of all headers in a document to build a table
/// of contents.
///
/// - parameter elements: The Markdown document you want to transform,
///   represented as an array of block-level elements.
/// - parameter f: The function that will be recursively applied to each 
///   block-level element in `elements`.
///
///   The function returns an array, which allows you to extract zero, one, or
///   multiple pieces of data from each element. Return an empty array to ignore
///   this element in the result.
/// - returns: A flattened array of the results of all invocations of `f`.
public func deepCollect<A>(_ elements: [Block], _ f: @escaping (Block) -> [A]) -> [A] {
    return elements.flatMap{deepCollect(f, $0)}
    
    //return elements.flatMap(deepCollect(f))
}

/// Performs a deep 'flatMap' operation over all _inline elements_ in a Markdown
/// document. Performs a deep traversal over all inline elements in the element
/// tree, applies `f` to each element, and returns the flattened results.
///
/// Use this function to extract data from a Markdown document. E.g. you could
/// extract the URLs from all links in a document.
///
/// - parameter elements: The Markdown document you want to transform,
///   represented as an array of block-level elements.
/// - parameter f: The function that will be recursively applied to each
///   inline element in `elements`.
///
///   The function returns an array, which allows you to extract zero, one, or
///   multiple pieces of data from each element. Return an empty array to ignore
///   this element in the result.
/// - returns: A flattened array of the results of all invocations of `f`.
public func deepCollect<A>(_ elements: [Block], _ f: @escaping (InlineElement) -> [A]) -> [A] {
    return elements.flatMap{deepCollect(f, $0)}//(deepCollect(f))
}

private func deepCollect<A>(_ f: @escaping (Block) -> [A], _ element: Block) -> [A] {
    let recurse: (Block) -> [A] = {deepCollect(f, $0)}//deepCollect(f)
   switch element {
   case .list(let items, _):
    return flatten(items).flatMap(recurse) + f(element)
   case .blockQuote(let items):
     return items.flatMap(recurse) + f(element)
   default:
     return f(element)
   }
}

private func deepCollect<A>(_ f: @escaping (InlineElement) -> [A], _ element: Block) -> [A] {
    let collectInline: (InlineElement) -> [A] = {deepCollect(f, $0)} //deepCollect(f)
    let recurse: (Block) -> [A] = {deepCollect(f, $0)} //deepCollect(f)
    switch element {
    case .paragraph(let children):
        return children.flatMap(collectInline)
    case let .list(items, _):
        return flatten(items).flatMap(recurse)
    case .blockQuote(let items):
        return items.flatMap(recurse)
    case let .header(text, _):
        return text.flatMap(collectInline)
    default:
        return []
    }
}

private func deepCollect<A>(_ f: @escaping (InlineElement) -> [A], _ element: InlineElement) -> [A] {
    let recurse: (InlineElement) -> [A] = {deepCollect(f, $0)} //deepCollect(f)
    switch element {
    case .emphasis(let children):
        return children.flatMap(recurse) + f(element)
    case .strong(let children):
        return children.flatMap(recurse) + f(element)
    case let .link(children, _, _):
        return children.flatMap(recurse) + f(element)
    case let .image(children, _, _):
        return children.flatMap(recurse) + f(element)
    default:
        return f(element)
    }
}


/// Return all block-level elements in a Markdown document that satisfy the
/// predicate `f`. Performs a deep traversal of the element tree.
///
/// - parameter elements: The Markdown document you want to filter, represented
///   as an array of block-level elements.
/// - parameter f: The predicate. Return `true` if the element should be
///   included in the results, `false` otherwise.
/// - returns: A Markdown document containing the filtered results, represented
///   as an array of block-level elements.
public func deepFilter(_ f: (Block) -> Bool, _ elements: [Block]) -> [Block] {
    return elements.flatMap{f($0) ? [$0] : []}
}

//private func deepFilter(_ f: @escaping (Block) -> Bool) -> ((Block) -> [Block]) {
//    return {f($0) ? [$0] : []}
//    
//    //    return deepCollect { element in
////        return f(element) ? [element] : []
////    }
//}

/// Return all inline elements in a Markdown document that satisfy the predicate
/// `f`. Performs a deep traversal of the element tree.
///
/// - parameter elements: The Markdown document you want to filter, represented
///   as an array of block-level elements.
/// - parameter f: The predicate. Return `true` if the element should be
///   included in the results, `false` otherwise.
/// - returns: An array containing the filtered results.
public func deepFilter(_ f: (InlineElement) -> Bool, _ elements: [Block]) -> [InlineElement] {
    return []
    //return elements.flatMap(deepFilter(f))
}

//private func deepFilter(_ f: @escaping (InlineElement) -> Bool) -> ((Block) -> [InlineElement]) {
//    return { (block: Block) -> [InlineElement] in
//        deepCollect(f, block)
//    }

    //    return deepCollect { element in
//        return f(element) ? [element] : []
//    }
//}





















