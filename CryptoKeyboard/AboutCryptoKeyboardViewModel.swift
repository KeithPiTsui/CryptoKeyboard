//
//  AboutCrytoKeyboardViewModel.swift
//  CryptoKeyboard
//
//  Created by Pi on 16/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

/// Call by other
public protocol AboutCryptoKeyboardViewModelInputs {
    
    /// Call when the view did load
    func viewDidLoad()
    
    /// Call when the view will appear with animated property
    func viewWillAppear(animated: Bool)
    
    /// Call when user tap on feedback row
    func tapFeedback()
}


/// Emits Siganl outside
public protocol AboutCryptoKeyboardViewModelOutputs {
    var goToSendEmailFeedback: Signal<String, NoError> {get}
}

public protocol AboutCryptoKeyboardViewModelType {
    var inputs: AboutCryptoKeyboardViewModelInputs {get}
    var outputs: AboutCryptoKeyboardViewModelOutputs {get}
}

public final class AboutCryptoKeyboardViewModel: AboutCryptoKeyboardViewModelType, AboutCryptoKeyboardViewModelInputs, AboutCryptoKeyboardViewModelOutputs {
    
    public init() {
        self.goToSendEmailFeedback = self.tapFeedbackProperty.signal.map({ return "Hello"})
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty()
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let viewWillAppearProperty = MutableProperty<Bool?>(nil)
    public func viewWillAppear(animated: Bool) {
        self.viewWillAppearProperty.value = animated
    }
    
    fileprivate let tapFeedbackProperty = MutableProperty()
    public func tapFeedback() {
        self.tapFeedbackProperty.value = ()
    }
    
    public var goToSendEmailFeedback: Signal<String, NoError>
    
    
    public var inputs: AboutCryptoKeyboardViewModelInputs {return self}
    public var outputs: AboutCryptoKeyboardViewModelOutputs { return self}
}














