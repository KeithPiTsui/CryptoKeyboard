//
//  SwiftAST.swift
//  CommonMark
//
//  Created by Chris Eidhof on 22/05/15.
//  Copyright (c) 2015 Unsigned Integer. All rights reserved.
//

import Foundation

/// The type of a list in Markdown, represented by `Block.List`.
public enum ListType {
    case unordered
    case ordered
}

/// An inline element in a Markdown abstract syntax tree.
public enum InlineElement {
    case text(text: String)
    case softBreak
    case lineBreak
    case code(text: String)
    case inlineHtml(text: String)
    case emphasis(children: [InlineElement])
    case strong(children: [InlineElement])
    case link(children: [InlineElement], title: String?, url: String?)
    case image(children: [InlineElement], title: String?, url: String?)
}

extension InlineElement : ExpressibleByStringLiteral {
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(stringLiteral: value)
    }
    
    public init(stringLiteral: StringLiteralType) {
        self = InlineElement.text(text: stringLiteral)
    }
}

/// A block-level element in a Markdown abstract syntax tree.
public enum Block {
    case list(items: [[Block]], type: ListType)
    case blockQuote(items: [Block])
    case codeBlock(text: String, language: String?)
    case html(text: String)
    case paragraph(text: [InlineElement])
    case header(text: [InlineElement], level: Int)
    case horizontalRule
}

func parseInlineElement(_ node: Node) -> InlineElement {
    let parseChildren = { node.children.map(parseInlineElement) }
    switch node.type {
    case CMARK_NODE_TEXT: return .text(text: node.literal!)
    case CMARK_NODE_SOFTBREAK: return .softBreak
    case CMARK_NODE_LINEBREAK: return .lineBreak
    case CMARK_NODE_CODE: return .code(text: node.literal!)
    case CMARK_NODE_HTML_INLINE: return .inlineHtml(text: node.literal!)
    case CMARK_NODE_EMPH: return .emphasis(children: parseChildren())
    case CMARK_NODE_STRONG: return .strong(children: parseChildren())
    case CMARK_NODE_LINK: return .link(children: parseChildren(), title: node.title, url: node.urlString)
    case CMARK_NODE_IMAGE: return .image(children: parseChildren(), title: node.title, url: node.urlString)
    default:
        fatalError("Expected inline element, got \(node.typeString)")
    }
}

public func parseListItem(_ node: Node) -> [Block] {
    switch node.type {
    case CMARK_NODE_ITEM:
        return node.children.map(parseBlock)
    default:
        fatalError("Unrecognized node \(node.typeString), expected a list item")
    }
}

public func parseBlock(_ node: Node) -> Block {
    let parseInlineChildren = { node.children.map(parseInlineElement) }
    let parseBlockChildren = { node.children.map(parseBlock) }
    switch node.type {
    case CMARK_NODE_PARAGRAPH:
        return .paragraph(text: parseInlineChildren())
    case CMARK_NODE_BLOCK_QUOTE:
        return .blockQuote(items: parseBlockChildren())
    case CMARK_NODE_LIST:
        let type = node.listType == CMARK_BULLET_LIST ? ListType.unordered : ListType.ordered
        return .list(items: node.children.map(parseListItem), type: type)
    case CMARK_NODE_CODE_BLOCK:
        return .codeBlock(text: node.literal!, language: node.fenceInfo)
    case CMARK_NODE_HTML_BLOCK:
        return .html(text: node.literal!)
    case CMARK_NODE_HEADING:
        return .header(text: parseInlineChildren(), level: node.headerLevel)
    case CMARK_NODE_THEMATIC_BREAK:
        return .horizontalRule
    default:
        fatalError("Unrecognized node: \(node.typeString)")
    }
}

extension Node {
    convenience init(type: cmark_node_type, literal: String) {
        self.init(type: type)
        self.literal = literal
    }
    convenience init(type: cmark_node_type, blocks: [Block]) {
        self.init(type: type, children: blocks.map(toNode))
    }
    convenience init(type: cmark_node_type, elements: [InlineElement]) {
        self.init(type: type, children: elements.map(toNode))
    }

    public convenience init(blocks: [Block]) {
        self.init(type: CMARK_NODE_DOCUMENT, blocks: blocks)
    }
}

extension Node {
    /// The abstract syntax tree representation of a Markdown document.
    /// - returns: an array of block-level elements.
    public var elements: [Block] {
        return children.map(parseBlock)
    }
}


func toNode(_ element: InlineElement) -> Node {
    let node: Node
    switch element {
    case .text(let text):
        node = Node(type: CMARK_NODE_TEXT, literal: text)
    case .emphasis(let children):
        node = Node(type: CMARK_NODE_EMPH, elements: children)
    case .code(let text):
         node = Node(type: CMARK_NODE_CODE, literal: text)
    case .strong(let children):
        node = Node(type: CMARK_NODE_STRONG, elements: children)
    case .inlineHtml(let text):
        node = Node(type: CMARK_NODE_HTML_INLINE, literal: text)
    case let .link(children, title, url):
        node = Node(type: CMARK_NODE_LINK, elements: children)
        node.title = title
        node.urlString = url
    case let .image(children, title, url):
        node = Node(type: CMARK_NODE_IMAGE, elements: children)
        node.title = title
        node.urlString = url
    case .softBreak: node = Node(type: CMARK_NODE_SOFTBREAK)
    case .lineBreak: node = Node(type: CMARK_NODE_LINEBREAK)
    }
    return node
}

func toNode(_ block: Block) -> Node {
   let node: Node
   switch block {
   case .paragraph(let children):
     node = Node(type: CMARK_NODE_PARAGRAPH, elements: children)
   case let .list(items, type):
     let listItems = items.map { Node(type: CMARK_NODE_ITEM, blocks: $0) }
     node = Node(type: CMARK_NODE_LIST, children: listItems)
     node.listType = type == .unordered ? CMARK_BULLET_LIST : CMARK_ORDERED_LIST
   case .blockQuote(let items):
     node = Node(type: CMARK_NODE_BLOCK_QUOTE, blocks: items)
   case let .codeBlock(text, language):
     node = Node(type: CMARK_NODE_CODE_BLOCK, literal: text)
     node.fenceInfo = language
   case .html(let text):
     node = Node(type: CMARK_NODE_HTML_BLOCK, literal: text)
   case let .header(text, level):
     node = Node(type: CMARK_NODE_HEADING, elements: text)
     node.headerLevel = level
   case .horizontalRule:
     node = Node(type: CMARK_NODE_THEMATIC_BREAK)
   }
   return node
}
