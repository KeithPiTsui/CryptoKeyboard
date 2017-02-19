//
//  KeyboardViewModel.swift
//  CryptoKeyboard
//
//  Created by Pi on 16/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import Library


protocol KeyboardViewModelInputs {
    
    /// Call when an event occur on a key
    func event(_ e: UIControlEvents, on key: Key)
    
    /// Call when change keyboard
    func changeKeyboard(_ mode: Keyboard.Mode)
    
    /// Call when the view did load.
    func viewDidLoad()
    
    /// Call when the view will appear with animated property.
    func viewWillAppear(animated: Bool)

}

protocol KeyboardViewModelOutputs {
    
    /// Emits an keyboardDiagram that should be displayed
    var keyboardDiagram: Signal<Diagram<Key>, NoError> { get }
    
    /// Emits a signal to notify change keyboard to system keyboard
    var changeToSystemKeyboard: Signal<(), NoError> { get }
    
    /// Emits a signal to notify delete a character backward pressBackspace
    var deleteCharacterBackward: Signal<(), NoError> {get}
    
    /// Emits a signal to notify stop deleting a character
    var stopDeletingCharacterBackward: Signal<(), NoError> {get}
    
    /// Emits a signal to notify highlight a key
    var highlightKey: Signal<Key, NoError>{get}
    
    /// Emits a signal to notify unhihglight a key
    var unhighlightKey: Signal<Key, NoError> {get}
    
    /// Emits a sginal to notify output a key which has output string
    var outputOneKey: Signal<Key, NoError> {get}
    
    /// Emits a signal to notify play click sound
    var clickSound: Signal<(), NoError> {get}
    
    /// Emits a signal to notify go to setting page
    var goToSetting: Signal<(), NoError> {get}
    
    /// Emits a signal to notify shift down
    var shiftDown: Signal<(), NoError> {get}
    
    /// Emits a signal to notify double tapped shift
    var shiftDoubletapped: Signal<(), NoError> {get}
    
    
}

protocol KeyboardViewModelType {
    var inputs: KeyboardViewModelInputs { get }
    var outputs: KeyboardViewModelOutputs { get}
}

internal final class KeyboardViewModel: KeyboardViewModelType, KeyboardViewModelInputs, KeyboardViewModelOutputs {
    

    
    public init() {
        keyboardDiagram = changeKeyboardProperty.signal.map{ (mode) -> Diagram<Key> in
            switch mode {
            case .defaultKeyboard: return Keyboard.defaultKeyboardDiagram
            case .numberPunctuationKeyboard: return Keyboard.numberPunctuationKeyboardDiagram
            case .numberSymbolKeyboard: return Keyboard.symbolKeyboardDiagram
            case .alphaKeyboard: return Keyboard.alphaKeyboardDiagram
            case .numericKeyboard: return Keyboard.numberKeyboardDiagram
            }
        }
        
        /// .touchUpInside, to: .keyboardChange
        changeToSystemKeyboard = eventOnKeyProperty.signal.skipNil()
            .filter{ $0.0 == .touchUpInside && $0.1.type == .keyboardChange }
            .map{_ in ()}
        
        deleteCharacterBackward = eventOnKeyProperty.signal.skipNil()
            .filter{ $0.0 == .touchDown && $0.1.type == .backspace }
            .map{_ in ()}
        
        stopDeletingCharacterBackward = eventOnKeyProperty.signal.skipNil()
            .filter{
                [.touchDragExit, .touchUpOutside,
                 .touchCancel, .touchDragOutside,
                 .touchUpInside].contains($0.0)
                    && $0.1.type == .backspace
            }
            .map{_ in ()}
        

        highlightKey = eventOnKeyProperty.signal.skipNil()
            .filter{
                [.touchDown, .touchDragInside,
                 .touchDragEnter].contains($0.0)
                    && $0.1.isHighlightable
            }
            .map{return $0.1}

        unhighlightKey = eventOnKeyProperty.signal.skipNil()
            .filter{
                [.touchUpInside, .touchUpOutside,
                 .touchDragOutside].contains($0.0)
                    && $0.1.isHighlightable
            }
            .map{return $0.1}
        
        outputOneKey = eventOnKeyProperty.signal.skipNil()
            .filter{ $0.0 == .touchUpInside && $0.1.hasOutput }
            .map{return $0.1}
        
        clickSound = eventOnKeyProperty.signal.skipNil().filter{$0.0 == .touchDown}.map{_ in ()}
        
        goToSetting = eventOnKeyProperty.signal.skipNil()
            .filter{ $0.0 == .touchUpInside && $0.1.type == .settings }
            .map{_ in ()}
        
        shiftDown = eventOnKeyProperty.signal.skipNil()
            .filter{ $0.0 == .touchDown && $0.1.type == .shift }
            .map{_ in ()}

        shiftDoubletapped = eventOnKeyProperty.signal.skipNil()
            .filter{ $0.0 == .touchDownRepeat && $0.1.type == .shift }
            .map{_ in ()}
        
        eventOnKeyProperty.signal.skipNil()
            .filter{ $0.0 == .touchUpInside && $0.1.type == .modeChange }
            .map{$0.1}
            .observeValues { [weak self] key in
                guard let mode = key.toMode else { return }
                self?.changeKeyboardProperty.value = mode
            }
        
        viewDidLoadProperty.signal
            .observeValues { [weak self] in self?.changeKeyboardProperty.value = .defaultKeyboard }

    }
    
    // MARK: -
    // MARK: Inputs
    fileprivate let eventOnKeyProperty = MutableProperty<(UIControlEvents, Key)?>(nil)
    func event(_ e: UIControlEvents, on key: Key) {
        self.eventOnKeyProperty.value = (e, key)
    }
    
    fileprivate let changeKeyboardProperty = MutableProperty<Keyboard.Mode>(.defaultKeyboard)
    func changeKeyboard(_ mode: Keyboard.Mode) {
        self.changeKeyboardProperty.value = mode
    }
    
    
    fileprivate let tappedKeyProperty = MutableProperty<Key?>(nil)
    public func tappedKey(_ key: Key) {
        self.tappedKeyProperty.value = key
    }
    
    
    fileprivate let viewDidLoadProperty = MutableProperty()
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }

    fileprivate let viewWillAppearProperty = MutableProperty<Bool?>(nil)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    // MARK: -
    // MARK: Outputs
    
    public let keyboardDiagram: Signal<Diagram<Key>, NoError>
    public let changeToSystemKeyboard: Signal<(), NoError>
    public let deleteCharacterBackward: Signal<(), NoError>
    public let stopDeletingCharacterBackward: Signal<(), NoError>
    public let highlightKey: Signal<Key, NoError>
    public let unhighlightKey: Signal<Key, NoError>
    public let outputOneKey: Signal<Key, NoError>
    public let clickSound: Signal<(), NoError>
    public let goToSetting: Signal<(), NoError>
    public let shiftDown: Signal<(), NoError>
    public let shiftDoubletapped: Signal<(), NoError>
    
    var inputs: KeyboardViewModelInputs { return self }
    var outputs: KeyboardViewModelOutputs { return self }
}










