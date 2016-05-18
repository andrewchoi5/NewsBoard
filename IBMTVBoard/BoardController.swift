
//
//  BoardController.swift
//  IBMTVBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class BoardController: UIViewController, BoardLayoutDelegate, DateSelectorDelegate {
    static let updateIntervalInSeconds = 5.0
    
    let cellsPerRow = 5
    let cellsPerColumn = 4
    
    let DefaultCardCellIdentifier           = "defaultCardCell"
    let AnnouncementCardCellIdentifier      = "announcementCardCell"
    let IdeaCardCellIdentifier              = "ideaCardCell"
    let QuestionCardCellIdentifier          = "questionCardCell"
    let RFPCardCellIdentifier               = "rfpCardCell"
    let ArticleCardCellIdentifier           = "articleCardCell"
    let VideoCardCellIdentifier             = "videoCardCell"
    var timer : NSTimer!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    let dateSelector = DateSelectorController()
    let layout = BoardLayout()
    let boardDate = BoardDate()
    
    var cardList = [ Card ]()
    
    @IBAction func didPressNextDayButton() {
        flipAllCells()
        boardDate.incrementByDay()
        self.reload()
        dateLabel.text = getDateString(boardDate)
    }
    
    @IBAction func didPressPreviousDayButton() {
        flipAllCells()
        boardDate.decrementByDay()
        self.reload()
        dateLabel.text = getDateString(boardDate)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.tag = 1010101
        label.hidden = true
        label.textColor = UIColor.errorRed()
        label.font = UIFont.defaultFontOfSize(30.0)
        self.view.addSubview(label)
        
        self.beginLoadingState()
        self.reload()
        dateLabel.text = getDateString(boardDate)

//        dateSelector.delegate = self
//        
//        self.addChildViewController(dateSelector)
//        dateSelector.view.frame = self.view.bounds
//        self.view.addSubview(dateSelector.view)
//        dateSelector.didMoveToParentViewController(self)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(BoardController.updateIntervalInSeconds, target: self, selector: #selector(BoardController.reload), userInfo: nil, repeats: true)
    }
    
    func flipAllCells() {
        for cell in self.collectionView.visibleCells() {
            
            if (cell.contentView.subviews.count > 2) {
                
                for c in (cell.contentView.subviews) {
                    
                    if c.tag == 1 {
                        for cellContent in (cell.contentView.subviews[1].subviews) {
                            if (cellContent.hidden == true) {
                                cellContent.hidden = false
                            }
                        }
                        
                        if (cell.contentView.subviews[1].subviews.count == 6) {
                            cell.contentView.subviews[1].subviews[3].hidden = true
                        }
                        
                        c.removeFromSuperview()
                        UIView.transitionWithView(cell, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: nil, completion: nil)
                    }
                    
                }
                
            }
            
        }
    }
    
    func beginNoNetworkState() {
        errorLabel.text = "No Connection"
        errorLabel.hidden = false
        collectionView.hidden = true
        
    }
    
    func endNoNetworkState() {
        collectionView.hidden = false
        errorLabel.hidden = true
    }
    
    func getDateString(date : BoardDate) -> String {
        
        if date.underlyingDate().isYesterday() {
            return "Yesterday, \(boardDate.mediumDateString())"
            
        } else if date.underlyingDate().isToday() {
            return "Today, \(boardDate.mediumDateString())"
            
        } else if date.underlyingDate().isTomorrow() {
            return "Tomorrow, \(boardDate.mediumDateString())"
            
        }
        
        return date.mediumDateString()
        
    }
    
    func showNoCardsState() {
        guard let noCardsLabel = self.view.viewWithTag(1010101) as? UILabel else { return }
        noCardsLabel.text = "No posts for this day"
        noCardsLabel.sizeToFit()
        noCardsLabel.center.x = self.view.frame.width / 2
        noCardsLabel.center.y = self.view.frame.height / 2
        noCardsLabel.hidden = false
        collectionView.hidden = true
        collectionView.userInteractionEnabled = false

    }
    
    func hideNoCardsState() {
        guard let noCardsLabel = self.view.viewWithTag(1010101) else { return }
        noCardsLabel.hidden = true
        
        collectionView.hidden = false
        collectionView.userInteractionEnabled = true
    }
    
    func beginLoadingState() {
        loadingView.alpha = 0.25
        activityIndicator.startAnimating()
    }
    
    func endLoadingState() {
        loadingView.alpha = 0.0
        activityIndicator.stopAnimating()
        
    }
    
    func reload() {
        if !ServerInterface.isConnectedToNetwork() {
            self.endLoadingState()
            self.hideNoCardsState()
            self.beginNoNetworkState()
            return
            
        }
        
        self.endNoNetworkState()
        ServerInterface.getCards(onDate: boardDate.underlyingDate()) { (cards) in
        
            if cards.count == 0 {
                self.showNoCardsState()
                
            } else {
                self.hideNoCardsState()
                
            }
            
            let oldDeck = Set<Card>(self.cardList)
            let newDeck = Set<Card>(cards)
        
            let deletedCards = oldDeck.subtract(newDeck)
            let addedCards = newDeck.subtract(oldDeck)
            var leftOverCards = newDeck.intersect(oldDeck)
        
            for card in addedCards {
                self.cardList.append(card)
                let indexPath = NSIndexPath(forRow: self.cardList.count - 1, inSection:0)
                self.collectionView.insertItemsAtIndexPaths([ indexPath ])
            
            }
        
            for index in 0 ..< self.cardList.count {
                let oldCard = self.cardList[ index ]
                if let card = leftOverCards.remove(oldCard) where oldCard.isOlderCardThan(card) {
                    let indexPath = NSIndexPath(forRow: index, inSection:0)
                    self.cardList[ index ] = card
                    self.collectionView.reloadItemsAtIndexPaths([ indexPath ])
                }
            }

            var deleted = 0
            for index in 0..<self.cardList.count {
                let realIndex = index - deleted
                let oldCard = self.cardList[ realIndex ]
                if deletedCards.contains(oldCard) {
                    let indexPath = NSIndexPath(forRow: realIndex, inSection:0)
                    self.cardList.removeAtIndex(realIndex)
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                    deleted += 1
                }
            }
        
            self.endLoadingState()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardList.count
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, rectForItemAtIndexPath indexPath: NSIndexPath) -> CGRect {
        
        let cell = cardList[indexPath.row]
        let blockWidth = (self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow)
        let blockHeight = (self.collectionView?.frame.size.height)! / CGFloat(cellsPerColumn)
        let xPos = CGFloat((cell.space.topLeftCorner - 1) % cellsPerRow) * blockWidth
        let yPos = CGFloat((cell.space.topLeftCorner - 1) / cellsPerRow) * blockHeight
        let width = blockWidth * CGFloat(cell.space.width)
        let height = blockHeight * CGFloat(cell.space.height)
        let rect = CGRectMake(xPos,yPos,width,height)
        return rect
    
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldUpdateFocusInContext context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }

    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        if let previousPath = context.previouslyFocusedIndexPath {
            if let previousCell = collectionView.cellForItemAtIndexPath(previousPath) {
                (previousCell as! CardCell).defocus()
                dateSelector.focusButtons()
                
            }
        }
        
        if let nextPath = context.nextFocusedIndexPath {
            if let nextCell = collectionView.cellForItemAtIndexPath(nextPath) {
                (nextCell as! CardCell).focus()
                
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        let cardCell = cardList[indexPath.row]
        
        if (cell?.contentView.subviews.count > 2)
        {
            for v in (cell?.contentView.subviews)!{
                if v.tag == 1 {
                    
                    // Unhide content hidden on cell flip
                    for cellContent in (cell?.contentView.subviews[1].subviews)! {
                        if (cellContent.hidden == true) {
                            cellContent.hidden = false
                        }
                    }
                    
                    //hide read more label in article cell
                    if (cell?.contentView.subviews[1].subviews.count == 6)
                    {
                        cell?.contentView.subviews[1].subviews[3].hidden = true
                    }
                    
                    v.removeFromSuperview()
                    UIView.transitionWithView(cell!, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: nil, completion: nil)
                }
            }
        }
        else if (cardCell.type! == CardCellType.Video || cardCell.type! == CardCellType.NewsArticle) {
            let qrCode = UIImageView.init()
            
            qrCode.image = QRCoder(card: cardCell).encodedImage()
            qrCode.frame = (cell?.bounds)!

            qrCode.frame = CGRectMake(qrCode.frame.origin.x, qrCode.frame.origin.y, 200, 200)
            qrCode.center = (cell?.contentView.convertPoint((cell?.contentView.center)!, fromView:cell?.contentView.superview))!
         
            qrCode.tag = 1
            
            cell?.contentView.addSubview(qrCode)
            
            // Hide content for cell flip
            for cellContent in (cell?.contentView.subviews[1].subviews)! {
                if (cellContent.hidden == false) {
                    cellContent.hidden = true
                }
            }

            UIView.transitionWithView(cell!, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let cellsRankedByXCoord = self.collectionView.visibleCells().sort { (cell1, cell2) -> Bool in
//            return cell1.frame.origin.x < cell2.frame.origin.x
//            
//        }
        
        guard let farLeftCell = (self.collectionView.visibleCells().maxElement { (cell1, cell2) -> Bool in
            cell1.frame.origin.x > cell2.frame.origin.x
            
        }) else {
            return
            
        }
        
        guard let farRightCell = (self.collectionView.visibleCells().minElement { (cell1, cell2) -> Bool in
            cell1.frame.origin.x > cell2.frame.origin.x
            
        }) else {
            return
            
        }
        
        let minX = farLeftCell.frame.origin.x
        let maxX = farRightCell.frame.origin.x
        
        for cell in self.collectionView.visibleCells() {
        
            let leftSwipeGesture = UISwipeGestureRecognizer()
            leftSwipeGesture.direction = .Left
            leftSwipeGesture.addTarget(self, action: #selector(BoardController.swipeLeft))
            
            let rightSwipeGesture = UISwipeGestureRecognizer()
            rightSwipeGesture.direction = .Right
            rightSwipeGesture.addTarget(self, action: #selector(BoardController.swipeRight))
            
            if cell.frame.origin.x == minX {
                cell.addGestureRecognizer(leftSwipeGesture)
                
            }
            
            if cell.frame.origin.x == maxX {
                cell.addGestureRecognizer(rightSwipeGesture)
                
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cellIdentifier : String
        
        let card = cardList[indexPath.row]
        
        switch card.type! {
            
            case .Default:      cellIdentifier = DefaultCardCellIdentifier
            case .Announcement: cellIdentifier = AnnouncementCardCellIdentifier
            case .Idea:         cellIdentifier = IdeaCardCellIdentifier
            case .Question:     cellIdentifier = QuestionCardCellIdentifier
            case .RFP:          cellIdentifier = RFPCardCellIdentifier
            case .NewsArticle:  cellIdentifier = ArticleCardCellIdentifier
            case .Video:        cellIdentifier = VideoCardCellIdentifier
            default:            cellIdentifier = DefaultCardCellIdentifier
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardCell
        cell.applyCardContent(card)
        return cell
    }
    
    func swipeLeft() {
        print("")
        
    }
    
    func swipeRight() {
        print("")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PostViewerController
//        vc.contentURL = NSURL(string: (sender as! Card).info["videoURL"] as! String)
    }
}
