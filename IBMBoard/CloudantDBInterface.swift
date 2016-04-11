//
//  CouchDBInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class CardsForDateInterval : Query {
    
    init(fromDate firstDate: NSDate, toDate secondDate: NSDate) {
        super.init()
        
        self.addSelector("card.postDates", .In, [ firstDate.shortDateString(), secondDate.shortDateString() ])
        self.addField("card")
//        self.addSortingParameter("_id", ordered: .Ascending)
//        self.limitToNumberOfResults(1)
    }
}

class AccountQuery : Query {
    
    override init() {
        super.init()
        
        self.addField("account")
    }
    
    convenience init(withEmail anEmail : String) {
        self.init()

        self.addSelector("account.email", .Equals, anEmail)
    }
    
    convenience init(withEmail anEmail : String, andPassword aPassword : String) {
        self.init()
        
        self.addSelector("account.email", .Equals, anEmail)
        self.addSelector("account.password", .Equals, aPassword)
        
    }
    
    convenience init(withVerificationCode aCode : String) {
        self.init()
        
        self.addSelector("account.verificationCode", .Equals, aCode)
    }
    
    
    
}

enum QuerySortDirection : String {
    case Ascending = "asc"
    case Descending = "desc"
}

enum QueryComparatorOperator : String {
    
    case Equals = "$eq"
    case GreaterThan = "$gt"
    case In = "$in"
    
}

class Query : NSObject {
    
    var selectors = [String : [String : AnyObject]]()
    var fields = [ String ]()
    var sort = [[String : String]]()
    var limit = 25
    
    override init() {
        super.init()
        
        self.addField("_id")
        self.addField("_rev")
        self.addField("_attachments")
        self.addSelector("hidden", .Equals, 0)
        self.addSelector("_id", .GreaterThan, 0)
        self.addSortingParameter("_id", ordered: .Ascending)

    }
    
    func addSelector(fieldName : String, comparator: QueryComparatorOperator, value: AnyObject) {
        selectors[fieldName] = [comparator.rawValue : value]
    }
    
    func addSelector(fieldName : String, _ comparator: QueryComparatorOperator, _ value: AnyObject) {
        selectors[fieldName] = [comparator.rawValue : value]
    }
    
    func addField(fieldName: String) {
        fields.append(fieldName)
    }
    
    func addFields(fieldNames: [String]) {
        fields.appendContentsOf(fieldNames)
    }
    
    func addSortingParameter(fieldName: String, ordered direction: QuerySortDirection) {
        sort.append([ fieldName : direction.rawValue ])
    }
    
    
    func limitToNumberOfResults(num : Int) {
        limit = num
    }
}

class Document : NSObject {
    var id : String!
    var revision : String!
    var infoKey : String!
    var info = [String : AnyObject]()
    var attachments = [ String : [ String : AnyObject ] ]()
    
    override var hashValue: Int {
        return revision.hashValue ^ id.hashValue
    }
    
    func updateWithDocumentMetaData(metaData : DocumentMetaData) {
        id = metaData.id
        revision = metaData.revision
        
    }
    
    init(dictionary : [ String : AnyObject ]) {
        super.init()
        
        id = dictionary["_id"] as! String
        revision = dictionary["_rev"] as! String
        if let attachDict = dictionary["_attachments"] as? [ String : [ String : AnyObject ] ] {
            attachments = attachDict
        }
        
        var keys = Set(dictionary.keys)
        keys.remove("_id")
        keys.remove("_rev")
        keys.remove("_attachments")
        infoKey = keys.removeFirst()
        
        info = dictionary[ infoKey ] as! [String : AnyObject]
        
    }
    
    init(document : Document) {
        super.init()
        
        id = document.id
        revision = document.revision
        infoKey = document.infoKey
        info = document.info
        attachments = document.attachments
    }
    
    func addAttachment(attachmentData: NSData, mimeType: String, name: String) {
        self.attachments[name] =
            [
                "content_type" : mimeType,
                "data" : attachmentData.base64EncodedString()
        ]
    }
    
    func addAttachment(attachmentData: NSData, mimeType: String) {
        self.addAttachment(attachmentData, mimeType: mimeType, name: "attachment\(attachments.count + 1)")
        
    }
    
    func addJPEGImage(image: UIImage, compressionRatio: CGFloat) {
        guard let imageData = UIImageJPEGRepresentation(image, compressionRatio) else { return }
        self.addAttachment(imageData, mimeType: "image/jpeg")
    }
    
    func addPNGImage(image: UIImage) {
        guard let imageData = UIImagePNGRepresentation(image) else { return }
        self.addAttachment(imageData, mimeType: "image/png")
    }
    
    func addJPEGImage(image: UIImage) {
        self.addJPEGImage(image, compressionRatio: 0.5)
    }
    
    func hasAttachments() -> Bool {
        return attachments.count > 0
    }
    
    func getAttachments() -> [ String : AnyObject ] {
        return attachments
    }
    
    override init() {
        super.init()
        
    }
}

func ==(lhs: Document, rhs: Document) -> Bool {
    return lhs.revision == rhs.revision && lhs.id == rhs.id
}

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
    
    internal var datesAppearing = Set<BoardDate>()
    
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
            datesAppearing.insert(date.boardDateFromShortString())
            
        }
        
    }
    
    func setBoardPostingDates(postingDates: Set<BoardDate>) {
        var boardDateSet = Set<BoardDate>()
        for date in postingDates {
            boardDateSet.insert(date)
        }
        self.datesAppearing = boardDateSet
        
    }
    
    
    func setPostingDates(postingDates: Set<NSDate>) {
        var boardDateSet = Set<BoardDate>()
        for date in postingDates {
            boardDateSet.insert(BoardDate(withDate: date))
        }
        self.datesAppearing = boardDateSet
        
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

class Account : Document {
    var email : String!
    var password : String!
    var verified = false
    var verificationCode : String {
        return String(email.hashValue ^ password.hashValue).base64EncodedString().stringByReplacingOccurrencesOfString("=", withString: "")
    }
    
    func verifyWithCode(code : String) -> Bool {
        verified = (code == verificationCode)
        return verified
        
    }
    
    init(withEmail anEmail: String, andPassword aPassword:String) {
        super.init()
        
        email = anEmail
        password = aPassword
        
    }
    
    override init(document: Document) {
        super.init()
        
        email = document.info["email"] as! String
        password = document.info["password"] as! String
        verified = document.info["verified"] as! Bool
    }
    
    static func testAccount() -> Account {
        return Account(withEmail: "zamiul.haque.1@gmail.com", andPassword: "testing123")
        
    }
}
