//
//  FrontCollectionViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 22/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit

final class FrontCollectionViewController: UICollectionViewController {

    var tags: [Int] = [1,2,3,4,5,6]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(CipherCollectionViewCell.self, forCellWithReuseIdentifier: CipherCollectionViewCell.classID)
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(FrontCollectionViewController.handleLongGesture(gesture:)))
        self.collectionView!.addGestureRecognizer(longPressGesture)
        
    }
    
    private var selectedCell: CipherCollectionViewCell?
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        guard isEditing else { return }
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView!.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView!.beginInteractiveMovementForItem(at: selectedIndexPath)
            guard let cell = collectionView!.cellForItem(at: selectedIndexPath) as? CipherCollectionViewCell else { break }
            selectedCell = cell
            selectedCell?.getSelected = true
        case .changed:
            collectionView!.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView!.endInteractiveMovement()
            selectedCell?.getSelected = false
            selectedCell = nil
        default:
            collectionView!.cancelInteractiveMovement()
            selectedCell?.getSelected = false
            selectedCell = nil
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CipherCollectionViewCell.classID, for: indexPath)
        cell.tag = tags[indexPath.item]
        return cell
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension FrontCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let containerSize = collectionView.bounds.size
        let itemWidth = (containerSize.width - (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing)/2
        let itemHeight = (containerSize.height - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing * 2)/3
        return CGSize(itemWidth, itemHeight)
    }
}
