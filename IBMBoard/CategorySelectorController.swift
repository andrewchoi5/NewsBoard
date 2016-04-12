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

class CategorySelectorController : BoardViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let cellsPerRow = 2
    let cellsPerColumn = 4
    var optionImagesArray = [
                                ("Polling",            "polling"),
                                ("News Article",       "news"),
                                ("Announcements",      "announcement"),
                                ("New Idea",           "idea"),
                                ("Technical Question", "technical"),
                                ("RFP",                "handshake"),
                                ("Video",              "video"),
                                ("Guest Visit",        "visitor")
    
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
        if(UIDeviceOrientationIsLandscapeOrUnknown(UIDevice.currentDevice().orientation)) {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((self.collectionView?.frame.size.width)! / CGFloat(cellsPerRow), (self.collectionView?.frame.size.height)! / CGFloat(cellsPerColumn))
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionImagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var segueIdentifier = ""
        switch indexPath.row {
            
            case 0: segueIdentifier = pollingSegueIdentifier;       selectedCardSpace.type = .Polling
            case 1: segueIdentifier = newsSegueIdentifier;          selectedCardSpace.type = .NewsArticle
            case 2: segueIdentifier = announcementSegueIdentifier;  selectedCardSpace.type = .Announcement
            case 3: segueIdentifier = ideaSegueIdentifier;          selectedCardSpace.type = .Idea
            case 4: segueIdentifier = questionSegueIdentifier;      selectedCardSpace.type = .Question
            case 5: segueIdentifier = rfpSegueIdentifier;           selectedCardSpace.type = .RFP
            case 6: segueIdentifier = videoSegueIdentifier;         selectedCardSpace.type = .Video
            case 7: segueIdentifier = guestSegueIdentifier;         selectedCardSpace.type = .Guest
            
           default: segueIdentifier = placeholderSegueIdentifier;   selectedCardSpace.type = .Default
        }
        
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("typeCell", forIndexPath: indexPath)
        (cell.viewWithTag(2) as! UILabel).text = optionImagesArray[ indexPath.row ].0
        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: optionImagesArray[ indexPath.row ].1)
        
        return cell
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
