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

protocol KeyboardViewModelInputs {
    
}

protocol KeyboardViewModelOutputs {
    
}

protocol KeyboardViewModelType {
    var inputs: KeyboardViewModelInputs { get }
    var outputs: KeyboardViewModelOutputs { get}
}

internal final class KeyboardViewModel: KeyboardViewModelType, KeyboardViewModelInputs, KeyboardViewModelOutputs {
    
    public init() {
        
    }
    
    var inputs: KeyboardViewModelInputs { return self }
    var outputs: KeyboardViewModelOutputs { return self }
}
