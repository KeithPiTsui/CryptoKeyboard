//
//  CipherSettingViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 14/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol CipherSettingViewControllerDelegate: class {
    
}

class CipherSettingViewController: UIViewController {

    weak var delegate: CipherSettingViewControllerDelegate?
    
    lazy var cancelBtn: UIBarButtonItem = {
        let img = UIImage(named: "backArrow")!
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(CipherSettingViewController.cancel))
        return item
    }()
    
    lazy var doneBtn: UIBarButtonItem = {
        let img = UIImage(named: "checkedSymbol")!
        let item = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(CipherSettingViewController.cancel))
        item.tintColor = UIColor.barCheckedSymbolColor
        return item
    }()
    
    lazy var cipherTopBar: CipherSettingTopBarView = {
        let tb = CipherSettingTopBarView(withDelegate: self)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = doneBtn
        navigationItem.titleView = cipherTopBar
    }
    
    func cancel() {
        print("\(#function)")
        dismiss(animated: true, completion: nil)
    }
    
    func done() {
        print("\(#function)")
        dismiss(animated: true, completion: nil)
    }
}


extension CipherSettingViewController: CipherSettingTopBarViewDelegate {
    func valuesForDisplay() -> [String] {
        return ["A","B","C","D","E","F"]
    }
}




