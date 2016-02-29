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
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    // data structure for one cell (cellType, topLeftCorner, width, height)
    // Order by topLeftCorner
    let testCellList : [ (type: CardCellType, topLeftCorner: Int, width: Int, height: Int) ] = [
        
                        (.Announcement,   1, 3, 4),
                        (.Idea,           4, 3, 2),
                        (.Video,          7, 3, 2),
                        (.Announcement,  22, 3, 2),
                        (.Announcement,  25, 3, 2),
                        (.RFP,           37, 3, 2),
                        (.NewsArticle,   40, 3, 2),
                        (.Announcement,  43, 3, 2)
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testCellList.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, rectForItemAtIndexPath indexPath: NSIndexPath) -> CGRect {
        
        let cell = testCellList[indexPath.row]
        let blockWidth = (self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow)
        let blockHeight = (self.collectionView?.frame.size.height)! / CGFloat(cellsPerColumn)
        let xPos = CGFloat((cell.topLeftCorner - 1) % cellsPerRow) * blockWidth
        let yPos = CGFloat(cell.topLeftCorner / cellsPerRow) * blockHeight
        let width = blockWidth * CGFloat(cell.width)
        let height = blockHeight * CGFloat(cell.height)
        
        return CGRectMake(xPos,yPos,width,height)
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cellIdentifier : String
        
        switch testCellList[ indexPath.row ].type {
            
            case .Default:      cellIdentifier = DefaultCardCellIdentifier
            case .Announcement: cellIdentifier = DefaultCardCellIdentifier
            case .Idea:         cellIdentifier = DefaultCardCellIdentifier
            case .RFP:          cellIdentifier = DefaultCardCellIdentifier
            case .NewsArticle:  cellIdentifier = ArticleCardCellIdentifier
            case .Video:        cellIdentifier = VideoCardCellIdentifier
            
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardCell
        cell.userPhoto.image = UIImage(named: "\(indexPath.row + 1)")
        return cell
    }
    
}

