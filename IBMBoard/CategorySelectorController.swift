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

class CategorySelectorController : DefaultViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let cellsPerRow = 2
    let cellsPerColumn = 4
    
    // NOTE: Refer to icon font, included in this project to see what characters look like,
    // XCode cannot render unicode symbols on this screen
    var optionImagesArray = [
                                    ("Article",         ""),
                                    ("News",   ""),
                                    ("Idea",            ""),
                                    ("Tech Questions",  ""),
                                    ("RFP",             ""),
                                    ("Video",           ""),
                                    ("Photo",           ""),
                                    ("",                  ""),
                                    ("Polling",         ""),
                                    ("Guest Visits",    "")
    ]
    
    var pollingSegueIdentifier       = placeholderSegueIdentifier
    var newsSegueIdentifier          = "newsSegue"
    var announcementSegueIdentifier  = "announcementSegue"
    var ideaSegueIdentifier          = "ideaSegue"
    var questionSegueIdentifier      = "questionSegue"
    var rfpSegueIdentifier           = "rfpSegue"
    var videoSegueIdentifier         = "videoSegue"
    var photoSegueIdentifier         = "photoSegue"
    var guestSegueIdentifier         = placeholderSegueIdentifier
    
    var card : Card!
    
    var isSquare : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lockToPortrait()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PosterController
        vc.card = card
        
        if (segue.identifier == "photoSegue") {
            if (isSquare == false) {
                let alert = UIAlertController(title: "Error", message: "Please ensure the area selected is a square", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            (segue.destinationViewController as! AnnouncementPostController).isPhotoView = true
        }
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
        
        if indexPath.row == 7 {
            cell.userInteractionEnabled = false
        }
        
        if indexPath.row > 7 {
            let comingSoonLabel = UILabel()
            comingSoonLabel.backgroundColor = UIColor.backgroundDarkColor()
            comingSoonLabel.text = "Coming Soon!"
            comingSoonLabel.font = UIFont.defaultFontOfSize(16.0)
            comingSoonLabel.textColor = UIColor.textWhite()
            comingSoonLabel.textAlignment = .Center
            comingSoonLabel.sizeToFit()
            comingSoonLabel.frame.size.width = cell.frame.size.width
            comingSoonLabel.frame.origin = CGPointZero
            cell.contentView.addSubview(comingSoonLabel)
            
            let greyBox = UIView()
            greyBox.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
            greyBox.frame.origin = CGPointZero
            greyBox.frame.size.width = cell.frame.size.width
            greyBox.frame.size.height = cell.frame.size.height
            cell.contentView.addSubview(greyBox)
        }
        
        return cell
        
    }
    
}

extension CategorySelectorController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row <= 7
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row <= 7
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var segueIdentifier = ""
        switch indexPath.row {
            case 0: segueIdentifier = newsSegueIdentifier;          card.type = .NewsArticle
            case 1: segueIdentifier = announcementSegueIdentifier;  card.type = .Announcement
            case 2: segueIdentifier = ideaSegueIdentifier;          card.type = .Idea
            case 3: segueIdentifier = questionSegueIdentifier;      card.type = .Question
            case 4: segueIdentifier = rfpSegueIdentifier;           card.type = .RFP
            case 5: segueIdentifier = videoSegueIdentifier;         card.type = .Video
            case 6: segueIdentifier = photoSegueIdentifier;         card.type = .Announcement
            case 7: segueIdentifier = "";                           card.type = .Announcement
            case 8: segueIdentifier = pollingSegueIdentifier;       card.type = .Polling
            case 9: segueIdentifier = guestSegueIdentifier;         card.type = .Guest
                
            default: segueIdentifier = placeholderSegueIdentifier;   card.type = .Default
        }
        
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}

