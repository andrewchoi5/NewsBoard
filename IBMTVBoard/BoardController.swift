
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
    
    let DefaultCardCellIdentifier = "defaultCardCell"
    let AnnouncementCardCellIdentifier = "announcementCardCell"
    let IdeaCardCellIdentifier = "ideaCardCell"
    let RFPCardCellIdentifier = "rfpCardCell"
    let ArticleCardCellIdentifier = "articleCardCell"
    let VideoCardCellIdentifier = "videoCardCell"
    var timer : NSTimer!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let layout = BoardLayout()
    
    var cardList = [ Card ]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reload()
        
//        let id = "ruwxZfiC9dI"
//        let URL = NSURL(string: "http://www.youtube.com/v/\(id)")!
//        if UIApplication.sharedApplication().canOpenURL(URL) {
//            UIApplication.sharedApplication().openURL(URL)
//        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(BoardController.updateIntervalInSeconds, target: self, selector: #selector(BoardController.reload), userInfo: nil, repeats: true)
    }
    
    func reload() {
        ServerInterface.getCardsForToday({ (cards) in
            
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
            
            self.firstLoadCompletionRoutine()
        })
    }
    
    func firstLoadCompletionRoutine() {
        
        loadingView.alpha = 0.0
        activityIndicator.stopAnimating()
        
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
        
        return CGRectMake(xPos,yPos,width,height)
        
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if(context.previouslyFocusedIndexPath != nil && context.nextFocusedIndexPath != nil) {
            let previousCell = collectionView.cellForItemAtIndexPath(context.previouslyFocusedIndexPath!) as! CardCell
            let nextCell = collectionView.cellForItemAtIndexPath(context.nextFocusedIndexPath!) as! CardCell
            previousCell.defocus()
            nextCell.focus()
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
