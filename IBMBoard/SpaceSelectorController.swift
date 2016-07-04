//
//  SpaceSelectorController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

internal let cellsPerRow = 5
internal let cellsPerColumn = 4

class SpaceSelectorController : DefaultViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    @IBOutlet weak var tvPicker: UIPickerView!
    @IBOutlet var gradientView: GradientView!
        
    var postingDates = Set<BoardDate>()
    var newCard : Card!
    var cardHolderMatrix = [ (Int, Card?) ](count: cellsPerRow * cellsPerColumn, repeatedValue: (0, nil))
    var selectedSpaces = Set<Int>()
    var cardList = [ Card ]()
    var calendarDate = BoardDate()
    var datesToSearch = Set<NSDate>()
    var isSquareSelected : Bool!
    var officeTVs = [ TV ]()
    
    var userOrgName = String()
    var userOfficeName = String()
    var selectedTV = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lockToLandscape()
        
        datesToSearch.insert(NSDate())
        
        configureCurrentDateLabel()
        addGesturesRecognizers()
        // reload called in getTVNames, after the tv names for associated org and office has been obtained
        // reloadCards()
        
        
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
        
        self.tvPicker.delegate = self
        self.tvPicker.dataSource = self
        
        getTVNames()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.enabled = isRectangular(selectedSpaces) && postingDates.count > 0
    }
    
    func getTVNames() {
        
        ServerInterface.getUser(associateWithAccount: SessionInformation.currentSession.userAccount, completion:{
            (user) in
            self.userOrgName = (user?.org)!
            self.userOfficeName = (user?.office)!

            ServerInterface.getTV(associateWithOrgAndOffice: self.userOrgName, office: self.userOfficeName
                , completion: {
                (tvs) in
                self.officeTVs = tvs
                self.selectedTV = self.officeTVs[0].tv
                self.tvPicker.reloadAllComponents()
                self.reloadCards()
            })
        })
    }
    
    @IBAction func selectTV(sender: AnyObject) {
        print("select tv")
        tvPicker.hidden = false
        self.collectionView.userInteractionEnabled = false
        self.gridView.hidden = true
    }
    
    // MARK: UIPicker delegate methods
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return officeTVs.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return officeTVs[row].tv
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        print("selection made")
        tvPicker.hidden = true
        self.collectionView.userInteractionEnabled = false
        self.gridView.hidden = false
        
        selectedTV = officeTVs[row].tv
        
        self.reloadCards()
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
        
        ServerInterface.getCards(onDates: [ calendarDate.underlyingDate() ], withOrg: userOrgName, andOffice: userOfficeName, andTV: selectedTV, completion: {
            (cards) in
            self.cardList = cards
            self.reloadData()
            self.finishedReloading()
        })
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
    
    func isSquare(spaces: Set<Int>) -> Bool {
        if (spaces.count == 0) {
            return false
        }
        
        let rect = CGRectForSpaces(spaces)
        return rect.width == rect.height
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
            (segue.destinationViewController as! CategorySelectorController).isSquare = isSquareSelected
            (segue.destinationViewController as! CategorySelectorController).selectedTVName = selectedTV
            
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
        
        // draw the box around the cell indicating which card it is a member of
        if (card != nil) {
            let startIndex = card!.space.topLeftCorner - 1
            let height = card!.space.height
            let width = card!.space.width
            
            let cellRow = indexPath.row % cellsPerRow
            let cellCol = indexPath.row / cellsPerRow
            let topLeftRow = startIndex % cellsPerRow
            let topLeftCol = startIndex / cellsPerRow
            
            let leftEmpty = (topLeftRow == cellRow) ? true : false
            let topEmpty = (startIndex / cellsPerRow == cellCol) ? true : false
            let rightEmpty = ((topLeftRow + width - 1) == cellRow) ? true : false
            let bottomEmpty = ((topLeftCol + height - 1) == cellCol) ? true : false
            
            if let occupiedCell = cell as? OccupiedCellView {
                occupiedCell.drawCellRect(leftEmpty, topEmpty: topEmpty, rightEmpty: rightEmpty, bottomEmpty: bottomEmpty)
            }
        }
        
        return cell
    }
}

extension SpaceSelectorController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !isEmptyCell(indexPath) {
            return
        }
        
        selectedSpaces.insert(indexPath.row)
        doneButton.enabled = isRectangular(selectedSpaces) && postingDates.count > 0
        //isSquareSelected = isSquare(selectedSpaces)
        isSquareSelected = true
        
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