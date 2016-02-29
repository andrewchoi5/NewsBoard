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
    let vertical : CGFloat = 0.0
    let horizontal : CGFloat = 0.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    // data structure for one cell (topLeftCorner, width, height)
    // Order by topLeftCorner
    let testCellList : [ (topLeftCorner: Int, width: Int, height: Int) ] = [
        
                         (1, 3, 4),
                         (4, 3, 2),
                         (7, 3, 2),
                        (22, 3, 2),
                        (25, 3, 2),
                        (37, 3, 2),
                        (40, 3, 2),
                        (43, 3, 2)
    
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("defaultCardCell", forIndexPath: indexPath)
        return cell
    }
    
}

