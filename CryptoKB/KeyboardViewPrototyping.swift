//
//  KeyboardViewPrototyping.swift
//  CryptoKeyboard
//
//  Created by Pi on 24/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

protocol ViewPrototype {
    var frame: CGRect {get set}
    var center: CGPoint {get set}
    var bounds: CGRect {get set}
}

extension UIView : ViewPrototype {}

protocol KeyboardModelPrototype {
    
}

protocol KeyModelPrototype {
    
}


protocol KeyboardViewCellPrototype: ViewPrototype {
    init()
    var key: KeyModelPrototype {get set}
    
}

protocol KeyboardViewDataSourcePrototype {
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func keyboardView(_ keyboardView: KeyboardViewPrototype, cellForItemAt indexPath: IndexPath) -> KeyboardViewCellPrototype
    func numberOfCells(in keyboardView: KeyboardViewPrototype) -> Int
}

protocol KeyboardViewDelegatePrototype {
    func keyboardViewCell(_ cell: KeyboardViewCellPrototype, receivedEvent event: UIControlEvents, inKeyboard keyboard: KeyboardViewPrototype)
}

protocol KeyboardViewLayoutPrototype {
    
}

protocol KeyboardViewPrototype {
    var dataSource: KeyboardViewDataSourcePrototype {get}
    var delegate: KeyboardViewDelegatePrototype {get}
    var layout: KeyboardViewLayoutPrototype {get}
    
    /// Recording cell type and cell type id
    var cellTypeJournal: [String: KeyboardViewCellPrototype.Type] {get set}

    /// key available cell in pool for later use
    var cellPool: [String:[KeyboardViewCellPrototype]] {get set}
    
    /// Register a cell type with its id
    func register(_ cellType: KeyboardViewCellPrototype.Type, forCellWithReuseIdentifier cellTypeID: String)
    
    /// dequeue a cell from cell pool for use according to supplied cell type id, if no cell is available, create a new one
    func dequeueReusableCellWithReuseIdentifier(_ cellTypeID: String, forIndexPath indexPath: IndexPath) -> KeyboardViewCellPrototype
}

extension KeyboardViewPrototype {
    mutating func register(_ cellType: KeyboardViewCellPrototype.Type, forCellWithReuseIdentifier cellTypeID: String) {
        cellTypeJournal[cellTypeID] = cellType
    }
    
    mutating func dequeueReusableCellWithReuseIdentifier(_ cellTypeID: String, forIndexPath indexPath: IndexPath) -> KeyboardViewCellPrototype {
        if var cells = cellPool[cellTypeID], cells.isEmpty == false {
            let cell = cells.removeLast()
            cellPool[cellTypeID] = cells
            return cell
        } else {
            if let cellType =  cellTypeJournal[cellTypeID] {
                return cellType.init()
            }
        }
        fatalError("No available cell for given Cell type ID \(cellTypeID)")
    }
}











































