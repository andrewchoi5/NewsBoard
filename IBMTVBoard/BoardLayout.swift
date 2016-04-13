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

class BoardLayout : UICollectionViewFlowLayout {
    
    var delegate : BoardLayoutDelegate?
    var dataSource : UICollectionViewDataSource?
    
    override func prepareLayout() {
        super.prepareLayout()
     
        delegate = (self.collectionView?.delegate as! BoardLayoutDelegate)
        dataSource = self.collectionView?.dataSource
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if delegate == nil  {
            return nil
        }
        
        if dataSource == nil {
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
    
//    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        
//        let attributes = self.collectionView?.layoutAttributesForItemAtIndexPath(itemIndexPath)
//        attributes!.alpha = 0.0
//        
////        let size = self.collectionView!.frame.size
////        attributes!.center = CGPointMake(size.width / 2.0, size.height / 2.0)
//        //        attributes?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(4.0, 4.0), CGFloat(M_PI))
//        //        attributes?.center = CGPointMake(CGRectGetMidX(self.collectionView!.bounds), CGRectGetMaxY(self.collectionView!.bounds))
//        return attributes
//    }
    
    
//    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        
//        let attributes = self.collectionView?.layoutAttributesForItemAtIndexPath(itemIndexPath)
//        attributes?.alpha = 1.0
//        return attributes
//        
//    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if delegate == nil {
            return nil
        }
        
        if dataSource == nil {
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