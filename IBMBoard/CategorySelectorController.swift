//
//  CategorySelectorController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-19.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

private let placeholderSegueIdentifier = "placeholderSegue"

class CategorySelectorController : UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let cellsPerRow = 2
    let cellsPerColumn = 4
    /*
    var optionImagesArray = [
                                ("News Article",       "news"),
                                ("Announcements",      "announcement"),
                                ("New Idea",           "idea"),
                                ("Technical Question", "technical"),
                                ("RFP",                "handshake"),
                                ("Video",              "video"),
                                ("Polling",            "polling"),
                                ("Guest Visit",        "visitor")
    
    ]
 */
    
    var optionImagesArray = [
                                    ("Article",       ""),
                                    ("Announcements",      ""),
                                    ("Idea",           ""),
                                    ("Tech Questions", ""),
                                    ("RFP",                ""),
                                    ("Video",              ""),
                                    ("Polling",            ""),
                                    ("Guest Visits",        "")
    ]
    
    var pollingSegueIdentifier       = placeholderSegueIdentifier
    var newsSegueIdentifier          = "newsSegue"
    var announcementSegueIdentifier  = "announcementSegue"
    var ideaSegueIdentifier          = "ideaSegue"
    var questionSegueIdentifier      = placeholderSegueIdentifier
    var rfpSegueIdentifier           = "rfpSegue"
    var videoSegueIdentifier         = "videoSegue"
    var guestSegueIdentifier         = placeholderSegueIdentifier
    
    var selectedCardSpace : Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rotateToPortraitIfNeeded()
        
    }
    
    func rotateToPortraitIfNeeded() {
        if(!UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PosterController
        vc.selectedCardSpace = selectedCardSpace
    }
}

extension CategorySelectorController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow), (self.collectionView?.frame.size.height)! / CGFloat(cellsPerColumn))
        
    }
    
}

extension CategorySelectorController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionImagesArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("typeCell", forIndexPath: indexPath)
        (cell.viewWithTag(2) as! UILabel).text = optionImagesArray[ indexPath.row ].0
        
        (cell.viewWithTag(1) as! UILabel).text = optionImagesArray[ indexPath.row ].1
        cell.selectedBackgroundView = backgroundView
        
        if indexPath.row > 5 {
            let comingSoonLabel = UILabel()
            comingSoonLabel.backgroundColor = UIColor.backgroundDarkColor()
            comingSoonLabel.text = "Coming Soon!"
            comingSoonLabel.font = defaultFontOfSize(16.0)
            comingSoonLabel.textColor = UIColor.textWhite()
            comingSoonLabel.textAlignment = .Center
            comingSoonLabel.frame.origin = CGPointZero
            comingSoonLabel.sizeToFit()
            comingSoonLabel.frame.size.width = cell.frame.size.width
            cell.contentView.addSubview(comingSoonLabel)
            
        }
        
        return cell
        
    }
    
}

extension CategorySelectorController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row <= 5
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var segueIdentifier = ""
        switch indexPath.row {
            case 0: segueIdentifier = newsSegueIdentifier;          selectedCardSpace.type = .NewsArticle
            case 1: segueIdentifier = announcementSegueIdentifier;  selectedCardSpace.type = .Announcement
            case 2: segueIdentifier = ideaSegueIdentifier;          selectedCardSpace.type = .Idea
            case 3: segueIdentifier = questionSegueIdentifier;      selectedCardSpace.type = .Question
            case 4: segueIdentifier = rfpSegueIdentifier;           selectedCardSpace.type = .RFP
            case 5: segueIdentifier = videoSegueIdentifier;         selectedCardSpace.type = .Video
            case 6: segueIdentifier = pollingSegueIdentifier;       selectedCardSpace.type = .Polling
            case 7: segueIdentifier = guestSegueIdentifier;         selectedCardSpace.type = .Guest
                
            default: segueIdentifier = placeholderSegueIdentifier;   selectedCardSpace.type = .Default
        }
        
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}

