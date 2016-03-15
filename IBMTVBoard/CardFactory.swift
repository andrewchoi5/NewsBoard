//
//  CardFactory.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-15.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class CardFactory {
    
    class func makeCard(cardType: CardCellType, corner: Int, aWidth: Int, aHeight: Int) -> Card {
        return Card(cardType: cardType, corner: corner, aWidth: aWidth, aHeight: aHeight)
    }
    
    class func makeCard(corner: Int, aWidth: Int, aHeight: Int) -> Card {
        return Card(corner: corner, aWidth: aWidth, aHeight: aHeight)
        
    }
    
}

extension CardFactory {
    
    class func makeVideoCard(space: Space, _ title: String, _ videoURLString: String) -> Card {
        let card = makeCard(.Video, corner: space.topLeftCorner, aWidth: space.width, aHeight: space.height)
        card.info["videoTitle"] = title
        card.info["videoURL"] = videoURLString
        return card
        
    }
    
    class func makeArticleCard(space: Space, _ title: String, _ previewText: String) -> Card {
        let card = makeCard(.NewsArticle, corner: space.topLeftCorner, aWidth: space.width, aHeight: space.height)
        card.info["articleTitle"] = title
        card.info["articlePreviewText"] = previewText
        return card
        
    }
    
    class func makeAnnouncementCard(space: Space, _ title: String, _ messageBody: String) -> Card {
        let card = makeCard(.Announcement, corner: space.topLeftCorner, aWidth: space.width, aHeight: space.height)
        card.info["announcementTitle"] = title
        card.info["announcementText"] = messageBody
        return card
        
    }
    
    class func makePictureAnnouncementCard(space: Space, _ title: String, _ messageBody: String, _ picture: UIImage) -> Card {
        let card = makeAnnouncementCard(space, title, messageBody)
        card.addPNGImage(picture)
        return card
        
    }
    
    class func makeIdeaCard(space: Space, _ title: String, _ ideaPreview: String) -> Card {
        let card = makeCard(.Idea, corner: space.topLeftCorner, aWidth: space.width, aHeight: space.height)
        card.info["ideaTitle"] = title
        card.info["ideaPreview"] = ideaPreview
        return card
        
    }
    
    class func makeRFPCard(space: Space, _ title: String, _ RFPPreview: String) -> Card {
        let card = makeCard(.RFP, corner: space.topLeftCorner, aWidth: space.width, aHeight: space.height)
        card.info["RFPTitle"] = title
        card.info["RFPPreview"] = RFPPreview
        return card
        
    }
    
}

class CardTestSets {
    
    class func requirementsDemo() -> [ Card ] {
        
        let announcementTitle1 = "Please join us this Thursday"
        let announcementBody1 = ""
        let announcementPicture1 = UIImage(named: "pizza")!
        let ideaTitle1 = "App Idea"
        let ideaBody1 = "This space can be used to share interesting ideas about new app, features, potential clients, etc"
        let videoTitle1 = "Check out CES 2016 Highlights"
        let videoURL1 = "https://www.youtube.com/watch?v=eKkp30UCtUM"
        let announcementTitle2 = "Donations"
        let announcementBody2 = "A refugee family living in our neighbourhood. Please donate your gently used clothes if you have any"
        let announcementTitle3 = "Volunteer Needed"
        let annoucementBody3 = "A graphic designer for 1-2 days to work on an App prototype for a RFP response."
        let RFPTitle1 = "Help with RFP Response"
        let RFPBody1 = "Anyone with some experience working with HL7 standard in the healthcare domain?"
        let articleTitle1 = "Interesting Article"
        let articlePreview1 = "Where will IBM be heading with Watson? Interesting read"
        let announcementTitle4 = "Table Tennis"
        let announcementBody4 = "Anyone interested to play table tennis around 5:30?"
        
        return [
        
            CardFactory.makePictureAnnouncementCard(Space(1, 3,  4), announcementTitle1,  announcementBody1, announcementPicture1),
            CardFactory.makeIdeaCard(               Space(4, 3,  2), ideaTitle1,          ideaBody1),
            CardFactory.makeVideoCard(              Space(7, 3,  2), videoTitle1,         videoURL1),
            CardFactory.makeAnnouncementCard(       Space(22, 3, 2), announcementTitle2,  announcementBody2),
            CardFactory.makeAnnouncementCard(       Space(25, 3, 2), announcementTitle3,  annoucementBody3),
            CardFactory.makeRFPCard(                Space(37, 3, 2), RFPTitle1,           RFPBody1),
            CardFactory.makeArticleCard(            Space(40, 3, 2), articleTitle1,       articlePreview1),
            CardFactory.makeAnnouncementCard(       Space(43, 3, 2), announcementTitle4,  announcementBody4)
            
        ]
        
    }
    
}