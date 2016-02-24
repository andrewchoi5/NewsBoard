//
//  CategorySelectorController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-19.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class CategorySelectorController : UICollectionViewController {
    
    let cellsPerRow = 2
    var optionImagesArray = [
                                ("Polling","polling"),
                                ("","news"),
                                ("Announcements","announcement"),
                                ("New Idea","idea"),
                                ("Technical Question","technical"),
                                ("RFP","handshake"),
                                ("Video","video"),
                                ("Guest Visit","visitor")
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rotateToPortraitIfNeeded()
        
    }
    
    func rotateToPortraitIfNeeded() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow), (self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow))
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionImagesArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var segueIdentifier = ""
        switch indexPath.row {
            case 0: segueIdentifier = "pollingSegue"
            case 1: segueIdentifier = "newsSegue"
            case 2: segueIdentifier = "announcementSegue"
            case 3: segueIdentifier = "ideaSegue"
            case 4: segueIdentifier = "questionSegue"
            case 5: segueIdentifier = "rfpSegue"
            case 6: segueIdentifier = "videoSegue"
            case 7: segueIdentifier = "guestSegue"
            
           default: segueIdentifier = "videoSegue"
        }
        
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("typeCell", forIndexPath: indexPath)
        (cell.viewWithTag(2) as! UILabel).text = optionImagesArray[ indexPath.row ].0
        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: optionImagesArray[ indexPath.row ].1)
        
        return cell
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [ .Portrait ]
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
}
