//
//  CipherIntroductionViewController.swift
//  CryptoKeyboard
//
//  Created by Pi on 19/12/2016.
//  Copyright © 2016 Keith. All rights reserved.
//

import UIKit



final class CipherIntroductionViewController: UIViewController {

    var tags: [Int] = [1,2,3,4,5,6]
    
    static let editingNotification = Notification.Name("editingNotification")
    
    private var selectedCell: CipherCollectionViewCell?
    
    lazy var itemGridView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CipherCollectionViewCell.self, forCellWithReuseIdentifier: CipherCollectionViewCell.classID)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return collectionView
    }()

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        NotificationCenter.default.post(name: CipherIntroductionViewController.editingNotification, object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CryptoKeyboard"
        navigationItem.rightBarButtonItem = editButtonItem
        view.backgroundColor = UIColor.darkGray
        automaticallyAdjustsScrollViewInsets =  false
        assembleUIElements()
        
        let drag = UIPanGestureRecognizer(target: self, action: #selector(CipherIntroductionViewController.gestureHandler(_:)))
        view.addGestureRecognizer(drag)
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(CipherIntroductionViewController.gestureHandler(_:)))
//        view.addGestureRecognizer(longPress)
        
    }
    
    func longPresse(_ gestureRecognizer: UIGestureRecognizer) {
        print("Long Press")
    }
    
    func gestureHandler(_ gestureRecognizer: UIGestureRecognizer) {
        guard isEditing else { return }
        
        switch gestureRecognizer.state {
        case .began:
            let loc = gestureRecognizer.location(in: itemGridView)
            if selectedCell == nil {
                selectedCell = selectingCell(onPosition: loc)
                guard selectedCell != nil else { return }
                itemGridView.beginInteractiveMovementForItem(at: IndexPath(item: selectedCell!.tag, section: 0))
            } else {
                itemGridView.updateInteractiveMovementTargetPosition(loc)
            }
        case .cancelled:
            itemGridView.cancelInteractiveMovement()
        case .ended:
            itemGridView.endInteractiveMovement()
        default:
            break
        }
    }
    
    private func selectingCell(onPosition position: CGPoint) -> CipherCollectionViewCell? {
        guard itemGridView.bounds.contains(position) && !itemGridView.subviews.isEmpty else { return nil}
        var closest: (CipherCollectionViewCell?, CGFloat) = (nil, CGFloat.greatestFiniteMagnitude)
        for view in itemGridView.subviews {
            guard !view.isHidden else { continue }
            view.alpha = 1
            let distance = distanceBetween(view.frame, point: position)
            if distance < closest.1 {
                guard let view = view as? CipherCollectionViewCell else { continue }
                closest = (view, distance)
            }
        }
        return closest.0!

    }
    
    private func distanceBetween(_ rect: CGRect, point: CGPoint) -> CGFloat {
        if rect.contains(point) {return 0 }
        
        var closest = rect.origin
        
        if (rect.origin.x + rect.size.width < point.x) {
            closest.x += rect.size.width
        } else if (point.x > rect.origin.x) {
            closest.x = point.x
        }
        if (rect.origin.y + rect.size.height < point.y) {
            closest.y += rect.size.height
        } else if (point.y > rect.origin.y) {
            closest.y = point.y
        }
        
        let a = pow(Double(closest.y - point.y), 2)
        let b = pow(Double(closest.x - point.x), 2)
        return CGFloat(sqrt(a + b));
    }

    
    private func assembleUIElements () {
        view.addSubview(itemGridView)
        itemGridView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        itemGridView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        itemGridView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        itemGridView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}

extension CipherIntroductionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let containerSize = itemGridView.bounds.size
        let itemWidth = (containerSize.width - (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing)/2
        let itemHeight = (containerSize.height - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing * 2)/3
        return CGSize(itemWidth, itemHeight)
    }
}


extension CipherIntroductionViewController: UICollectionViewDelegate {
    
}

extension CipherIntroductionViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CipherCollectionViewCell.classID, for: indexPath)
        cell.tag = tags[indexPath.item]
        return cell
    }
    
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}






















