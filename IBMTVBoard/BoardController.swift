
//
//  BoardController.swift
//  IBMTVBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class BoardController: UIViewController, BoardLayoutDelegate {

    static let updateIntervalInSeconds = 5.0
    
    let cellsPerRow = 7
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
    
    let layout = BoardLayout()
    
    var cardList = [ Card ]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.tag = 1010101
        label.hidden = true
        label.textColor = UIColor.errorRed()
        label.text = "No Posts for Today"
        label.font = UIFont.defaultFontOfSize(30.0)
        label.sizeToFit()
        label.center.x = self.view.frame.width / 2
        label.center.y = self.view.frame.height / 2
        self.view.addSubview(label)
        
        self.beginLoadingState()
        self.reload()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(BoardController.updateIntervalInSeconds, target: self, selector: #selector(BoardController.reload), userInfo: nil, repeats: true)
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
    
    func showNoCardsState() {
        guard let noCardsLabel = self.view.viewWithTag(1010101) else { return }
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
        ServerInterface.getCardsForToday() { (cards) in
        
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
        
            for index in 0..<self.cardList.count {
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
                
                if CGRectGetMinX(collectionView.frame) + CGRectGetMaxX(previousCell.frame) >= collectionView.frame.width {
                    print("edge")
                    
                }
                
            }
        }
        
        if let nextPath = context.nextFocusedIndexPath {
            if let nextCell = collectionView.cellForItemAtIndexPath(nextPath) {
                (nextCell as! CardCell).focus()
                
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("viewPostSegue", sender: cardList[ indexPath.row ])
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PostViewerController
        vc.contentURL = NSURL(string: (sender as! Card).info["videoURL"] as! String)
    }
    
}
