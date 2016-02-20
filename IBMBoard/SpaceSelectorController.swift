//
//  SpaceSelectorController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class SpaceSelectorController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var emptyCellIdentifier = "emptyCell"
    var lockedCellIdentifier = "lockedCell"
    var crossedCellIdentifier = "crossedCell"
    var completedSpaceSelectionSegue = "completedSpaceSelectionSegue"
    var selectedSpace : (Int, Int, Int)!
    
    let cellsPerRow = 5
    let cellsPerColumn = 5
    
    var selectedSpaces = Set<Int>()
    
    var testArray = [ 1, 1, 0, 0, 0,
                      1, 1, 0, 0, 0,
                      1, 1, 0, 2, 2,
                      0, 0, 0, 2, 2,
                      0, 0, 0, 0, 0

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.allowsMultipleSelection = true
        
    }
    
    @IBAction func didFinishSelectingSpace(sender: AnyObject) {
        
        if(!isRectangular(selectedSpaces)) {
            print("Error: Select an appropriate rectangular area before submitting")
            return
        }
        
        selectedSpace = makeSelectedSpaceTuple(selectedSpaces)
        
        print("Spaces selected: \(selectedSpaces)")
        print("Space selected: \(selectedSpace)")
        
        self.performSegueWithIdentifier(completedSpaceSelectionSegue, sender: self)
        
    }
    
    func makeSelectedSpaceTuple(var spaces: Set<Int>) -> (Int, Int, Int) {
        var minimumElement = Int.max
        var maximumElement = Int.min
        while !spaces.isEmpty {
            let element = spaces.removeFirst()
            minimumElement = min(element, minimumElement)
            maximumElement = max(element, maximumElement)
            
        }
        
        let width = maximumElement % cellsPerRow - minimumElement % cellsPerRow + 1
        let height = (maximumElement - width + 1 - minimumElement) / cellsPerColumn + 1
        
        return (minimumElement, width, height)
    }
    
    // TODO: Optimize this function
    func isRectangular(var spaces: Set<Int>) -> Bool {
        var cellsInEachColumn = Dictionary<Int,Int>()
        
        while !spaces.isEmpty {
            let index = spaces.removeFirst() % cellsPerRow
            if(cellsInEachColumn[ index ] == nil) {
                cellsInEachColumn[index] = 1
                
            } else {
                cellsInEachColumn[index] = cellsInEachColumn[index]! + 1
                
            }
        }
        
        // Quick & dirty way to see if all values in cellsInEachColumn are the same
        var indexCount = 0
        var sampleIndex = 0
        for (_, count) in cellsInEachColumn {
            sampleIndex = count
            indexCount += count
        }
        
        return Double(indexCount) / Double(sampleIndex) == Double(cellsInEachColumn.count)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow), (self.collectionView?.frame.size.height)! / CGFloat(cellsPerColumn))
        
    }

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellsPerRow * cellsPerColumn
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedSpaces.insert(indexPath.row)
//        print("added \(indexPath.row)")
//        print("Space is rectangular: \(isRectangular(selectedSpaces))")
        if(isRectangular(selectedSpaces)) {
            print("Space selected: \(makeSelectedSpaceTuple(selectedSpaces))")
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        selectedSpaces.remove(indexPath.row)
//        print("removed \(indexPath.row)")
//        print("Space is rectangular: \(isRectangular(selectedSpaces))")
        if(isRectangular(selectedSpaces)) {
            print("Space selected: \(makeSelectedSpaceTuple(selectedSpaces))")
        }

    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellType = testArray[ indexPath.row ]
        
        var identifier = ""
        
        if(cellType == 0) {
            identifier = emptyCellIdentifier
            
        } else if(cellType == 1) {
            identifier = lockedCellIdentifier
            
        } else if(cellType == 2) {
            identifier = crossedCellIdentifier
            
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        return cell
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [ .LandscapeLeft ]
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .LandscapeLeft
    }
    
    
    
}