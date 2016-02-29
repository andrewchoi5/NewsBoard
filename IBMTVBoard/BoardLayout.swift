//
//  BoardLayout.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-29.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

@objc protocol BoardLayoutDelegate : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, rectForItemAtIndexPath indexPath: NSIndexPath) -> CGRect    
}

class BoardLayout : UICollectionViewLayout {
    
    var delegate : BoardLayoutDelegate?
    var dataSource : UICollectionViewDataSource?
    
    override func prepareLayout() {
        super.prepareLayout()
     
        delegate = (self.collectionView?.delegate as! BoardLayoutDelegate)
        dataSource = self.collectionView?.dataSource
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if(delegate == nil) {
            return nil
        }
        
        if(dataSource == nil) {
            return nil
        }
        
        let cellCount = (dataSource?.collectionView(collectionView!, numberOfItemsInSection: 0))!
        
        var attributesArray : [UICollectionViewLayoutAttributes]? = []
        
        for index in 0..<cellCount {
            let indexPathOfCell = NSIndexPath(forRow: index, inSection: 0)
            let contentRect = delegate!.collectionView(collectionView!, layout: self, rectForItemAtIndexPath: indexPathOfCell)
            if(CGRectIntersectsRect(contentRect, rect) || CGRectContainsRect(rect, contentRect)) {
                let newAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPathOfCell)
                newAttribute.frame = contentRect
                attributesArray!.append(newAttribute)
            }
        }
        
        return attributesArray
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if(delegate == nil) {
            return nil
        }
        
        if(dataSource == nil) {
            return nil
        }
        
        let contentRect = delegate!.collectionView(collectionView!, layout: self, rectForItemAtIndexPath: indexPath)
        
        let newAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        newAttribute.indexPath = indexPath
        newAttribute.frame = contentRect
        
        
        return Optional(newAttribute)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(1920 - 2 * 10,1080 - 2 * 10)
    }
}