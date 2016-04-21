//
//  CouchDBInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class CardQuery : Query {
    
    override init() {
        super.init()
        
        self.addField("card")
//        self.addSortingParameter("_id", ordered: .Ascending)
//        self.limitToNumberOfResults(1)
        
    }
    
    convenience init(withStartingDate firstDate: NSDate, toEndingDate secondDate: NSDate) {
        self.init()
        
        self.addSelector("card.postDates", .In, [ firstDate.shortDateString(), secondDate.shortDateString() ])

    }
    
    convenience init(withID ID: String) {
        self.init()
        
        self.addSelector("_id", .Equals, ID)
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
        self.addSelector("account.password", .Equals, Account.hashPassword(aPassword))
        
    }
    
    convenience init(withVerificationCode aCode : String) {
        self.init()
        
        self.addSelector("account.verificationCode", .Equals, aCode)
    }
    
    convenience init(withCard card: Card) {
        self.init()
        
        self.addSelector("_id", .Equals, card.associatedAccountID)
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

class Document {
    var id : String!
    var revision : String!
    var infoKey : String!
    var info = [String : AnyObject]()
    var attachments = [ String : [ String : AnyObject ] ]()
    
    func updateWithDocumentMetaData(metaData : DocumentMetaData) {
        id = metaData.id
        revision = metaData.revision
        
    }
    
    func hasNoMetaData() -> Bool {
        return id == nil && revision == nil
    }
    
    init(dictionary : [ String : AnyObject ]) {
        
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
        
        id = document.id
        revision = document.revision
        infoKey = document.infoKey
        info = document.info
        attachments = document.attachments
        
    }
    
    var revisionNumber : Int {
        guard let rangeOfDash = revision.rangeOfString("-") else { return 0 }
        guard let number = Int(revision.substringToIndex(rangeOfDash.endIndex.predecessor())) else { return 0 }
        return number
        
    }
    
    func isOlderRevisionThan(document: Document) -> Bool {
        return self.revisionNumber < document.revisionNumber
        
    }
    
    func setAttachment(withName name: String, andMIMEType mimeType: String, andData data: NSData) {
        self.attachments[name] =
            [
                "content_type" : mimeType,
                "data" : data.encodedBase64String()
        ]
    }
    
    func addAttachment(withMIMEType mimeType: String, andData data: NSData) {
        self.setAttachment(withName: "attachment\(attachments.count + 1)", andMIMEType: mimeType, andData: data)
        
    }
    
    private func attachJPEGImage(withName name: String, andData data: NSData) {
        self.setAttachment(withName: name, andMIMEType: "image/jpeg", andData: data)
        
    }
    
    func attachJPEGImage(withName name: String, withImage image: UIImage, andCompressionRatio ratio: CGFloat) {
        guard let reorientedImage = image.orientedCorrectly() else { return }
        guard let data = UIImageJPEGRepresentation(reorientedImage, ratio) else { return }
        self.attachJPEGImage(withName: name, andData: data)
        
    }
    
    func attachJPEGImage(withName name: String, andImage image: UIImage) {
        self.attachJPEGImage(withName: name, withImage: image, andCompressionRatio: 0.5)
        
    }
    
    func attachJPEGImage(image: UIImage) {
        self.attachJPEGImage(withName: "attachment\(attachments.count + 1)", andImage: image)
        
    }
    
    func attachPNGImage(withName name: String, andImage image: UIImage) {
        guard let reorientedImage = image.orientedCorrectly() else { return }
        guard let data = UIImagePNGRepresentation(reorientedImage) else { return }
        self.addAttachment(withMIMEType: "image/png", andData: data)
        
    }
    
    func attachPNGImage(image: UIImage) {
        self.attachPNGImage(withName: "attachment\(attachments.count + 1)", andImage: image)
        
    }
    
    func hasAttachments() -> Bool {
        return attachments.count > 0
    }
    
    func getAttachmentData(withName name: String) -> NSData? {
        guard let attachment = attachments[ name ] else { return nil }
        guard let base64String = attachment["data"] as? String else { return nil }
        guard let data = NSData(base64EncodedString: base64String, options: .IgnoreUnknownCharacters) else { return nil }
        return data
        
    }
    
    func getAttachmentURL(withName name: String, inDatabase dbName: String) -> NSURL? {
        return NSURL(string: "\(ServerInterface.serverURL)/\(dbName)/\(self.id)/\(name)")
        
    }
    
    func getAttachmentsDictionary() -> [ String : AnyObject ] {
        return attachments
        
    }
    
    init() {
        
    }
}

extension Document : Hashable {
    var hashValue: Int {
        return id.hashValue
        
    }
}

extension Document : Equatable { }

func ==(lhs: Document, rhs: Document) -> Bool {
    return lhs.id == rhs.id
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
    
    var associatedAccountID : String!
    var type : CardCellType!
    var space : Space!
    var userProvidedURL : NSURL? {
        guard let userProvidedURLString = self.info["userPhotoURL"] as? String else { return nil }
        guard let URL = NSURL(string: userProvidedURLString) else { return nil }
        
        return URL
    }
    
    var attachedImageURL : NSURL? {
        guard let name = super.getAttachmentsDictionary().keys.first else { return nil }
        return self.getAttachmentURL(withName: name, inDatabase: "ibmboard")
        
    }
    
    var attachedImage : UIImage? {
        guard let name = super.getAttachmentsDictionary().keys.first else { return nil }
        guard let data = self.getAttachmentData(withName: name) else { return nil }
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
        associatedAccountID = document.info["associatedAccountID"] as! String
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
    
    func isOlderCardThan(card: Card) -> Bool {
        return self.isOlderRevisionThan(card)
    }
    
    override init() {
        super.init()
        
    }
    
}

extension Card {
    var videoURL : NSURL? {
        get {
            
            guard let URLString = info["videoURL"] as? String else { return nil }
            guard let URL = NSURL(string: URLString) else { return nil }
            
            return URL
        }
        set(newValue) {
            
            guard let url = newValue else { return }
            info["videoURL"] = url.absoluteString
            
        }
        
    }
    var videoTitle : String? {
        get {
            
            guard let title = info["videoTitle"] as? String else { return nil }
            return title
        }
        set(newValue) {
            
            guard let title = newValue else { return }
            info["videoTitle"] = title
            
        }
    }
    
}

extension Card {
    var articleURL : NSURL? {
        get {
            
            guard let URLString = info["articleURL"] as? String else { return nil }
            guard let URL = NSURL(string: URLString) else { return nil }
            
            return URL
        }
        set(newValue) {
            
            guard let url = newValue else { return }
            info["articleURL"] = url.absoluteString
            
        }
        
    }
    
    var articleTitle : String? {
        get {
            
            guard let title = info["articleTitle"] as? String else { return nil }
            return title
        }
        set(newValue) {
            
            guard let title = newValue else { return }
            info["articleTitle"] = title
            
        }
    }
    
    var articlePreviewBody : String? {
        get {
            
            guard let title = info["articlePreviewText"] as? String else { return nil }
            return title
        }
        set(newValue) {
            
            guard let title = newValue else { return }
            info["articlePreviewText"] = title
            
        }
    }
}

class Account : Document {
    private static let hashSalt = "$2a$10$r6zvKtUDo4yvnc2u3Gww6u"
    
    var email : String!
    var password : String!
    var verified = false
    var verificationCode : String {
        let rawCode = String(abs(email.hashValue ^ password.hashValue))
        return rawCode.substringWithRange(Range<String.Index>(start: rawCode.startIndex, end: rawCode.startIndex.advancedBy(6)))
    }
    
    var profilePictureURL : NSURL? {
        return self.getAttachmentURL(withName: "profilePicture", inDatabase: "accounts")

    }
    
    func setProfilePicture(image : UIImage) {
        self.attachJPEGImage(withName: "profilePicture", andImage: image)
        
    }
    
    func hasProfilePicture() -> Bool {
        return self.hasAttachments()
        
    }
    
    func verifyWithCode(code : String) -> Bool {
        verified = (code == verificationCode)
        return verified
        
    }
    
    init(withEmail anEmail: String, andPassword aPassword:String) {
        super.init()
        
        email = anEmail
        password = Account.hashPassword(aPassword)
        
    }
    
    override init(document: Document) {
        super.init(document: document)
        
        email = document.info["email"] as! String
        password = document.info["password"] as! String
        verified = document.info["verified"] as! Bool
        
    }
    
    static func hashPassword(password: String) -> String {
        return password.hashedString(withSalt: Account.hashSalt)
        
    }
}

extension Account {
    static func testAccount() -> Account {
        return Account(withEmail: "zamiul.haque.1@gmail.com", andPassword: "zvqfr3")
        
    }
    
    static func testVerifiedAccount() -> Account {
        let account = Account.testAccount()
        account.verified = true
        return account
        
    }
    
}
