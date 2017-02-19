//
//  CipherInterpreterViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import Prelude
import Prelude_UIKit

class CipherInterpreterViewController: UIViewController {

    @IBOutlet weak var plaintextView: UITextView!
    @IBOutlet weak var encryptedTextView: UITextView!
    @IBOutlet weak var tranlateBtn: UIButton!
    @IBOutlet weak var keyStackView: UIStackView!
    @IBOutlet weak var keyEidtBtn: UIButton!
    
    internal static func instantiate() -> CipherInterpreterViewController {
        return Storyboard.CipherInterpreter.instantiate(CipherInterpreterViewController.self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func bindStyles() {
        _ = self.plaintextView |> UITextView.lens.backgroundColor %~ {_ in UIColor(43,181,255)}
        _ = self.plaintextView |> UITextView.lens.font %~ {_ in UIFont.translatorOriginalTextFont}
        _ = self.encryptedTextView |> UITextView.lens.backgroundColor %~ {_ in UIColor(249,252,255)}
        _ = self.encryptedTextView |> UITextView.lens.font %~ {_ in UIFont.translatorOriginalTextFont}
    }
    
    override func bindViewModel() {
        
        
        
    }
    
}
