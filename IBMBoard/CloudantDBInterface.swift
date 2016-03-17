//
//  CouchDBInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class PostsForDateInterval : Query {
    
    init(fromDate firstDate: NSDate, toDate secondDate: NSDate) {
        super.init()
        
        self.addSelector("_id", comparator: "$gt", value: 0)
        self.addSelector("card.postDates", comparator: "$in", value: [firstDate.shortDateString(), secondDate.shortDateString()])
        self.addField("card")
        self.addSortingParameter("_id", direction: .Ascending)
//        self.limitToNumberOfResults(1)
    }
}


enum QuerySortDirection : String {
    case Ascending = "asc"
    case Descending = "desc"
}

class Query : NSObject {
    
    var selector = [String : [String : AnyObject]]()
    var fields = [ String ]()
    var sort = [[String : String]]()
    var limit = 25
    
    override init() {
        super.init()
        
        self.addField("_id")
        self.addField("_rev")
        self.addField("_attachments")
        self.addSelector("hidden", comparator: "$eq", value: 0)
    }
    
    func addSelector(fieldName : String, comparator: String, value: AnyObject) {
        selector[fieldName] = [comparator : value]
    }
    
    func addField(fieldName: String) {
        fields.append(fieldName)
    }
    
    func addFields(fieldNames: [String]) {
        fields.appendContentsOf(fieldNames)
    }
    
    func addSortingParameter(fieldName: String, direction: QuerySortDirection) {
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