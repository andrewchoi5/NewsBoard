
//
//  BoardController.swift
//  IBMTVBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class BoardController: UIViewController, BoardLayoutDelegate {

    let cellsPerRow = 9
    let cellsPerColumn = 6
    
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
    var cardList = [Card]()

//    var cardList : [Card] = [
//        
//                        Card(cardType: .Announcement, corner: 1,  aWidth: 3, aHeight: 4),
//                        Card(cardType: .Idea,         corner: 4,  aWidth: 3, aHeight: 2),
//                        Card(cardType: .Video,        corner: 7,  aWidth: 3, aHeight: 2),
//                        Card(cardType: .Announcement, corner: 22, aWidth: 3, aHeight: 2),
//                        Card(cardType: .Announcement, corner: 25, aWidth: 3, aHeight: 2),
//                        Card(cardType: .RFP,          corner: 37, aWidth: 3, aHeight: 2),
//                        Card(cardType: .NewsArticle,  corner: 40, aWidth: 3, aHeight: 2),
//                        Card(cardType: .Announcement, corner: 43, aWidth: 3, aHeight: 2)
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reload()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "backgroundReload", userInfo: nil, repeats: true)
    }
    
    func reload() {
        ServerInterface.getAllPostsForToday({ (cards) in
                self.cardList = cards
                self.collectionView.reloadData()
                self.firstLoadCompletionRoutine()
        })
    }
    
    func backgroundReload() {
        ServerInterface.getAllPostsForToday({ (cards) in
            self.cardList = cards
            self.collectionView.reloadData()
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
        
        let cell = cardList[ indexPath.row ]
        let blockWidth = (self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow)
        let blockHeight = (self.collectionView?.frame.size.height)! / CGFloat(cellsPerColumn)
        let xPos = CGFloat((cell.space.topLeftCorner - 1) % cellsPerRow) * blockWidth
        let yPos = CGFloat(cell.space.topLeftCorner / cellsPerRow) * blockHeight
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
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cellIdentifier : String
        
        switch cardList[ indexPath.row ].type! {
            
            case .Default:      cellIdentifier = DefaultCardCellIdentifier
            case .Announcement: cellIdentifier = DefaultCardCellIdentifier
            case .Idea:         cellIdentifier = DefaultCardCellIdentifier
            case .RFP:          cellIdentifier = DefaultCardCellIdentifier
            case .NewsArticle:  cellIdentifier = ArticleCardCellIdentifier
            case .Video:        cellIdentifier = VideoCardCellIdentifier
            default:            cellIdentifier = DefaultCardCellIdentifier
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardCell
        // TODO: Get photo of user, using random samples
        cell.userPhoto.image = UIImage(named: "\(indexPath.row % 8 + 1)")
        cell.applyCardContent(cardList[ indexPath.row ])
        return cell
    }
    
}

