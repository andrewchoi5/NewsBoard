//
//  SpaceSelectorController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

internal let cellsPerRow = 7
internal let cellsPerColumn = 4

class SpaceSelectorController : DefaultViewController {
    
    let emptyCellIdentifier = "emptyCell"
    let lockedCellIdentifier = "lockedCell"
    let crossedCellIdentifier = "crossedCell"
    let completedSpaceSelectionSegue = "completedSpaceSelectionSegue"
    let calenderPopoverSegue = "calenderPopoverSegue"
    
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    var postingDates = Set<BoardDate>()
    var newCard : Card!
    var cardHolderMatrix = [ (Int, Card?) ](count: cellsPerRow * cellsPerColumn, repeatedValue: (0, nil))
    var selectedSpaces = Set<Int>()
    var cardList = [ Card ]()
    var calendarDate = BoardDate()
    var datesToSearch = Set<NSDate>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lockToLandscape()
        
        datesToSearch.insert(NSDate())
        
        configureCurrentDateLabel()
        addGesturesRecognizers()
        reloadCards()
        
        
        let normalAttributes = [
            
            NSForegroundColorAttributeName: UIColor.mainAccentGreen()
            
        ]
        
        let disabledAttributes = [
            
            NSForegroundColorAttributeName: UIColor.secondaryTextColor()
            
        ]
        
        doneButton.enabled = false
        doneButton.setTitleTextAttributes(normalAttributes, forState: .Normal)
        doneButton.setTitleTextAttributes(disabledAttributes, forState: .Disabled)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        
        self.postingDates.insert(calendarDate)
        
    }
    
    func configureCurrentDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        calendarButton.title = formatter.stringFromDate(calendarDate.underlyingDate())
    }
    
    func addGesturesRecognizers() {
        let swipeUp = UISwipeGestureRecognizer()
        swipeUp.direction = .Up
        swipeUp.addTarget(self, action: #selector(SpaceSelectorController.didSwipeUp))
        
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = .Down
        swipeDown.addTarget(self, action: #selector(SpaceSelectorController.didSwipeDown))
        
        self.collectionView.addGestureRecognizer(swipeUp)
        self.collectionView.addGestureRecognizer(swipeDown)
    }
    
    @IBAction func goNextDay(sender: AnyObject) {
        calendarDate.incrementByDay()
        configureCurrentDateLabel()
        self.reloadCards()
        
    }
    
    @IBAction func goPreviousDay(sender: AnyObject) {
        calendarDate.decrementByDay()
        configureCurrentDateLabel()
        self.reloadCards()
        
    }
    
    func reloadCards() {
        self.beginReloading()
        ServerInterface.getCards(onDates: [ calendarDate.underlyingDate() ]) { (cards) in
            self.cardList = cards
            self.reloadData()
            self.finishedReloading()
        }
    }
    
    func didSwipeUp() {
        // Replace with animation later
        toolBar.hidden = false
    }
    
    func didSwipeDown() {
        // Replace with animation later
        toolBar.hidden = true
    }
    
    func beginReloading() {
        activityIndicator.startAnimating()
        loadingScreen.alpha = 0.4
        collectionView?.userInteractionEnabled = false
    }
    
    func finishedReloading() {
        activityIndicator.stopAnimating()
        loadingScreen.alpha = 0.0
        collectionView?.userInteractionEnabled = true
        
    }
    
    
    func generateCardBoxes () {
        var c = 1
        for card in cardList {
            let startIndex = card.space.topLeftCorner - 1
            let height = card.space.height
            let width = card.space.width
            c = c + 1
            
            print("card: \(c), startIndex: \(startIndex), height : \(height), width : \(width)")
            
            if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? OccupiedCellView {
               cell.drawCellRect(false, topEmpty: false, rightEmpty: false, bottomEmpty: false)
                
            }
           
        }

    }
    
    func reloadData() {
        cardHolderMatrix = [ (Int, Card?) ](count: cellsPerRow * cellsPerColumn, repeatedValue: (0, nil))
        
        for card in cardList {
            let startIndex = card.space.topLeftCorner - 1
            for xIndex in 0 ..< card.space.width {
                for yIndex in 0 ..< card.space.height {
                    cardHolderMatrix[ startIndex + (yIndex * cellsPerRow) + xIndex ] = (1, card)
                }
            }
        }
        
        self.collectionView?.reloadData()
    }

    func openEditingActionSheet(withInvokingGesture gesture: CardEditingGesture) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Edit Content"
            , style: .Default, handler: { (action) in
                self.editCard(gesture.associatedCard)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) in
                self.deleteCard(gesture.associatedCard)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            
            actionSheet.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func didFinishSelectingSpace(sender: AnyObject) {
        
        newCard = makeCardWithSpaces(selectedSpaces)
        newCard.setBoardPostingDates(self.postingDates)
        // TODO: Refactor so that associated account ID is hidden and is replaced with object
        newCard.associatedAccountID = SessionInformation.currentSession.userAccount.id
        
        print("Spaces selected: \(selectedSpaces)")
        print("Space selected: \(newCard)")
        
        self.performSegueWithIdentifier(completedSpaceSelectionSegue, sender: self)
        
    }
    
    func makeCardWithSpaces(spaces: Set<Int>) -> Card {
        let rect = CGRectForSpaces(spaces)
        let width = Int(rect.width)
        let height = Int(rect.height)
        let topLeftCorner = Int(rect.origin.x) + Int(rect.origin.y - 1.0) * cellsPerRow + 1
        return Card(corner: topLeftCorner , aWidth: width, aHeight: height)
    }
    
    func CGRectForSpaces(spaces: Set<Int>) -> CGRect {
        if spaces.count <= 0 {
            return CGRectZero
        }
        
        var combinedRect = CGRectZero
        
        for space in spaces {
            let x = CGFloat(space % cellsPerRow)
            let y = CGFloat(Int(floor(Double( space ) / Double( cellsPerRow ))) + 1)
            let width = CGFloat(1)
            let height = CGFloat(1)
            
            let rect = CGRectMake(x, y, width, height)
            
            combinedRect = (CGRectEqualToRect(combinedRect, CGRectZero)) ?  rect : CGRectUnion(combinedRect, rect)
            
        }
        
        return combinedRect
    }
    
    func isRectangular(spaces: Set<Int>) -> Bool {
        if spaces.count == 0 {
            return false
        }
        
        let rect = CGRectForSpaces(spaces)
        return spaces.count == Int(rect.width * rect.height)
    }
    
    func isEmptyCell(indexPath: NSIndexPath) -> Bool {
        return collectionView!.cellForItemAtIndexPath(indexPath)!.reuseIdentifier == emptyCellIdentifier
        
    }
    
    func deleteCard(card : Card) {
        ServerInterface.deleteCard(card) {
            self.reloadCards()
            
        }
        
    }
    
    func editCard(card : Card) {
        
        let updateVideoCardSegue            = "updateVideoCardSegue"
        let updateArticleCardSegue          = "updateArticleCardSegue"
        let updateAnnouncementCardSegue     = "updateAnnouncementCardSegue"
        let updateQuestionCardSegue         = "updateQuestionCardSegue"
        let updateIdeaCardSegue             = "updateIdeaCardSegue"
        let updateRFPCardSegue              = "updateRFPCardSegue"
        
        let type = card.type!
        
        let segueIdentifier : String!
        
        switch type {
            
            case .Video:            segueIdentifier = updateVideoCardSegue
            case .NewsArticle:      segueIdentifier = updateArticleCardSegue
            case .Announcement:     segueIdentifier = updateAnnouncementCardSegue
            case .Question:         segueIdentifier = updateQuestionCardSegue
            case .Idea:             segueIdentifier = updateIdeaCardSegue
            case .RFP:              segueIdentifier = updateRFPCardSegue
            
            default : return
        }
        
        self.performSegueWithIdentifier(segueIdentifier, sender: card)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == completedSpaceSelectionSegue {
            let vc = segue.destinationViewController as! CategorySelectorController
            vc.card = newCard
            
        } else if segue.identifier == calenderPopoverSegue {
            let vc = segue.destinationViewController as! CalendarController
            vc.delegate = self
            
        } else {
            let vc = segue.destinationViewController as! PosterController
            vc.card = sender as! Card
            vc.updatingMode = true
        }

    }
    
    @IBAction func unwindToSpaceSelector(segue : UIStoryboardSegue) {
        selectedSpaces.removeAll()
        self.reloadCards()
    }
    
    
    func backButtonAction(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}

class CardEditingGesture : UITapGestureRecognizer {
    
    var associatedCard : Card!
    
}

extension SpaceSelectorController : PostDateSelector {
    func didAddPostingDate(date: NSDate) {
        postingDates.insert(BoardDate(withDate: date))
//        datesToSearch.insert(date)
//        self.reloadCards()
    }
    
    func didRemovePostingDate(date: NSDate) {
        postingDates.remove(BoardDate(withDate: date))
//        datesToSearch.remove(date)
//        self.reloadCards()
    }
    
    func hasPostingDate(date: NSDate) -> Bool {
        return postingDates.contains(BoardDate(withDate: date))
    }
    
    func didChangeStartingDate(date: NSDate) {
        calendarDate = BoardDate(withDate: date)
        configureCurrentDateLabel()
        self.reloadCards()
    }
    
    func startingDate() -> NSDate {
        return calendarDate.underlyingDate()
    }
    
}

extension SpaceSelectorController : UICollectionViewDataSource {
    
    
    override func viewDidLayoutSubviews() {
        generateCardBoxes()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsPerRow * cellsPerColumn
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellType = cardHolderMatrix[ indexPath.row ].0
        let card = cardHolderMatrix[ indexPath.row ].1
        
        let editGesture = CardEditingGesture(target: self, action: #selector(openEditingActionSheet))
        editGesture.associatedCard = card
        
        var identifier = ""
        
        if cellType == 0 {
            identifier = emptyCellIdentifier
            editGesture.enabled = false
            
        } else if cellType == 1 {
            identifier = lockedCellIdentifier
            
        } else if cellType == 2 {
            if SessionInformation.currentSession.hasAdminRights() {
                
                
            } else {
                identifier = crossedCellIdentifier
                
            }
            
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! DefaultCellView
        cell.addGestureRecognizer(editGesture)
        if cellType == 1 {
            //cell.drawCellRect(false, topEmpty: false, rightEmpty: false, bottomEmpty: false)
            print(" ITEM: \(indexPath.item) SECTION: \(indexPath.section)")
        }
        return cell
    }
}

/*
 func generateCardBoxes () {
 var c = 1;
 for card in cardList {
 let startIndex = card.space.topLeftCorner - 1
 var height = card.space.height
 var width = card.space.width
 c = c + 1;
 
 print("card: \(c), startIndex: \(startIndex), height : \(height), width : \(width)")
 
 }
 
 }
 */

extension SpaceSelectorController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !isEmptyCell(indexPath) {
            return
        }
        
        selectedSpaces.insert(indexPath.row)
        doneButton.enabled = isRectangular(selectedSpaces) && postingDates.count > 0
        
//        if isRectangular(selectedSpaces) && postingDates.count > 0  {
//            print("Space selected: \(makeCardWithSpaces(selectedSpaces))")
//            
//        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if !isEmptyCell(indexPath) {
            return
            
        }
        
        selectedSpaces.remove(indexPath.row)
        
        doneButton.enabled = isRectangular(selectedSpaces) && postingDates.count > 0
        
        
//        if isRectangular(selectedSpaces) && postingDates.count > 0 {
//            
//            print("Space selected: \(makeCardWithSpaces(selectedSpaces))")
//            
//        }
        
    }
    
}

extension SpaceSelectorController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let superviewHeight = self.collectionView!.frame.size.height
        let superviewWidth = self.collectionView!.frame.size.width
        let vLineWidths = CGFloat(cellsPerRow - 1) * 0.5
        let hLineWidths = CGFloat(cellsPerColumn - 1) * 0.5
        
        let width = (superviewWidth - vLineWidths) / CGFloat(cellsPerRow)
        let height = (superviewHeight - hLineWidths) / CGFloat(cellsPerColumn)
        return CGSizeMake(ceil(width), ceil(height))
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
}