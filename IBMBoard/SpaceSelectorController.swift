//
//  SpaceSelectorController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class SpaceSelectorController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, PostDateSelector {
    
    var emptyCellIdentifier = "emptyCell"
    var lockedCellIdentifier = "lockedCell"
    var crossedCellIdentifier = "crossedCell"
    var completedSpaceSelectionSegue = "completedSpaceSelectionSegue"
    var calenderPopoverSegue = "calenderPopoverSegue"
    
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var postingDates = Set<NSDate>()
    
    var emptyCardSpace : Card!
    
    let cellsPerRow = 9
    let cellsPerColumn = 6
    
    var selectedSpaces = Set<Int>()
    
    var cardList = [ Card ]()
    
    var cardHolderMatrix = [ (Int, Int) ](count: 9 * 6, repeatedValue: (0, 0))
    
    var calendarDate = NSDate()
    
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        calendarButton.title = formatter.stringFromDate(NSDate())
        
        self.collectionView?.allowsMultipleSelection = true
        
        
        ServerInterface.getPostsUntilDate(JTDateHelper().addToDate(NSDate(), days: 14)) { (cards) in
            self.cardList = cards
            self.reloadData()
            self.finishedReloading()
        }
        
        let swipeUp = UISwipeGestureRecognizer()
        swipeUp.direction = .Up
        swipeUp.addTarget(self, action: "didSwipeUp")
        
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = .Down
        swipeDown.addTarget(self, action: "didSwipeDown")
        
        self.collectionView.addGestureRecognizer(swipeUp)
        self.collectionView.addGestureRecognizer(swipeDown)
    }
    
    func didAddPostingDate(date: NSDate) {
        postingDates.insert(date)
    }
    
    func didRemovePostingDate(date: NSDate) {
        postingDates.remove(date)
    }
    
    func hasPostingDate(date: NSDate) -> Bool {
        return postingDates.contains(date)
    }
    
    func didChangeStartingDate(date: NSDate) {
        calendarDate = date
    }
    
    func startingDate() -> NSDate {
        return calendarDate
    }
    
    func didSwipeUp() {
        // Replace with animation later
        toolBar.hidden = false
    }
    
    func didSwipeDown() {
        // Replace with animation later
        toolBar.hidden = true
    }
    
    func finishedReloading() {
        
        activityIndicator.stopAnimating()
        collectionView?.userInteractionEnabled = true
        
    }
    
    func reloadData() {
        cardHolderMatrix = [ (Int, Int) ](count: 9 * 6, repeatedValue: (0, 0))
        
        var cardNumber = 0
        
        for card in cardList {
            let startIndex = card.space.topLeftCorner - 1
            for xIndex in 0 ..< card.space.width {
                for yIndex in 0 ..< card.space.height {
                    cardHolderMatrix[ startIndex + (yIndex * cellsPerRow) + xIndex ] = (1, cardNumber)
                }
            }
            cardNumber++
        }
        
        self.collectionView?.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rotateToLandscapeIfNeeded()
        
    }
 
    func rotateToLandscapeIfNeeded() {
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        }
    }
    
    @IBAction func didFinishSelectingSpace(sender: AnyObject) {
        
        if(!isRectangular(selectedSpaces)) {
            let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            let alert = UIAlertController(title: "Improper Selection", message: "Please select an appropriate rectangular area for your post!", preferredStyle: .Alert)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            print("Error: Select an appropriate rectangular area before submitting")
            return
        }
        
        emptyCardSpace = makeSelectedSpaceTuple(selectedSpaces)
        emptyCardSpace.setPostingDates(self.postingDates)
        
        print("Spaces selected: \(selectedSpaces)")
        print("Space selected: \(emptyCardSpace)")
        
        self.performSegueWithIdentifier(completedSpaceSelectionSegue, sender: self)
        
    }
    
    func makeSelectedSpaceTuple(var spaces: Set<Int>) -> Card {
        var minimumElement = Int.max
        var maximumElement = Int.min
        while !spaces.isEmpty {
            let element = spaces.removeFirst()
            minimumElement = min(element, minimumElement)
            maximumElement = max(element, maximumElement)
            
        }
        
        let width = maximumElement % cellsPerRow - minimumElement % cellsPerRow + 1
        let height = (maximumElement - width + 1 - minimumElement) / cellsPerRow + 1
        
        return Card(corner: minimumElement + 1, aWidth: width, aHeight: height)
    }
    
    func isRectangular(spaces: Set<Int>) -> Bool {
        if spaces.count <= 0 {
            return false
        }
        
        var combinedRect = CGRectZero
        
        for space in spaces {
            let x = CGFloat(space % cellsPerRow)
            let y = CGFloat(Int(floor(Double(space) / Double(cellsPerRow))) + 1)
            let width = CGFloat(1)
            let height = CGFloat(1)
            
            let rect = CGRectMake(x, y, width, height)
            
            combinedRect = (CGRectEqualToRect(combinedRect, CGRectZero)) ?  rect : CGRectUnion(combinedRect, rect)
            
        }
        
        return spaces.count == Int(combinedRect.width * combinedRect.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow), (self.collectionView?.frame.size.height)! / CGFloat(cellsPerColumn))
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellsPerRow * cellsPerColumn
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !isEmptyCell(indexPath) {
            return
        }
        
        selectedSpaces.insert(indexPath.row)

        if(isRectangular(selectedSpaces)) {
            print("Space selected: \(makeSelectedSpaceTuple(selectedSpaces))")
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if !isEmptyCell(indexPath) {
            return
            
        }
        
        selectedSpaces.remove(indexPath.row)
        if(isRectangular(selectedSpaces)) {
            print("Space selected: \(makeSelectedSpaceTuple(selectedSpaces))")
            
        }

    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellType = cardHolderMatrix[ indexPath.row ].0
        let cardNumber = cardHolderMatrix[ indexPath.row ].1
        
        var identifier = ""
        
        if cellType == 0 {
            identifier = emptyCellIdentifier
            
        } else if cellType == 1 {
            identifier = lockedCellIdentifier
            
        } else if cellType == 2 {
            if SessionInformation.currentSession.hasAdminRights() {
                
                
            } else {
                identifier = crossedCellIdentifier
                
            }
            
        }
                
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! DefaultCellView
        cell.setPhoto(UIImage(named: "\(cardNumber % 8 + 1)")!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func isEmptyCell(indexPath: NSIndexPath) -> Bool {
        return collectionView!.cellForItemAtIndexPath(indexPath)!.reuseIdentifier == emptyCellIdentifier
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [ .LandscapeLeft, .LandscapeRight ]
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .LandscapeLeft
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == completedSpaceSelectionSegue {
            let vc = segue.destinationViewController as! CategorySelectorController
            vc.selectedCardSpace = emptyCardSpace
            
        } else if segue.identifier == calenderPopoverSegue {
            let vc = segue.destinationViewController as! CalendarController
            vc.delegate = self
            
        }

    }
}