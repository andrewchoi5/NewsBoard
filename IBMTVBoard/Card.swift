//
//  Card.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-15.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

struct Space {
    
    var topLeftCorner : Int
    var width : Int
    var height : Int
    
    init(corner: Int, aWidth: Int, aHeight: Int) {
        
        topLeftCorner = corner
        width = aWidth
        height = aHeight
    }
    
    init(_ corner: Int, _ aWidth: Int, _ aHeight: Int) {
        
        topLeftCorner = corner
        width = aWidth
        height = aHeight
    }
    
    init(dictionary: [String: Int]) {
        
        topLeftCorner = dictionary["topLeftCorner"]!
        width = dictionary["width"]!
        height = dictionary["height"]!
        
    }
    
}

class Card : Document {
    
    var type : CardCellType!
    var space : Space!
    var attachedImageURLString : String {
        guard let attachmentName = super.getAttachments().keys.first else { return "" }
        return "\(ServerInterface.serverURL)/\(self.id)/\(attachmentName)"
    }
    
    var attachedImage : UIImage? {
        
        guard let attachment = super.getAttachments().values.first as? [ String : AnyObject ] else { return nil }
        guard let base64String = attachment["data"] as? String else { return nil }
        guard let data = NSData(base64EncodedString: base64String, options: .IgnoreUnknownCharacters) else { return nil }
        guard let image = UIImage(data: data) else { return nil }
        
        return image
    }
    
    private var datesAppearing = Set<NSDate>()
    
    init(cardType: CardCellType, corner: Int, aWidth: Int, aHeight: Int) {
        super.init()
        
        space = Space(corner: corner, aWidth: aWidth, aHeight: aHeight)
        type = cardType
        
    }
    
    init(corner: Int, aWidth: Int, aHeight: Int) {
        super.init()
        
        space = Space(corner: corner, aWidth: aWidth, aHeight: aHeight)
        type = .Default
        
    }
    
    override init(document: Document) {
        super.init(document: document)
        
        type = CardCellType(rawValue: document.info["type"] as! Int)
        info = document.info["info"] as! [String : AnyObject]
        space = Space(dictionary: document.info["space"]  as! [String : Int])
        setDatesWithTimestamps(document.info["postDates"] as? [ String ])
        
    }
    
    func setDatesWithTimestamps(dates:[ String ]?) {
        guard let postDates = dates else { return }
        for date in postDates {
            datesAppearing.insert(date.dateFromShortString())
            
        }
        
    }
    
    func setPostingDates(postingDates: Set<NSDate>) {
        self.datesAppearing = postingDates
        
    }
    
    func postDateStrings() -> [ String ] {
        var dateStrings = [ String ]()
        for date in datesAppearing {
            dateStrings.append(date.shortDateString())
        }
        return dateStrings
        
    }
    
    override init() {
        super.init()
        
    }
    
}
