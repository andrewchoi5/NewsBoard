//
//  ServerInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension NSJSONSerialization {
    
    public class func dataWithJSONObject(obj: AnyObject) -> NSData {
        do {
            return try NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions(rawValue: 0))
            
        } catch {
            return NSData()
        }
    }
    
    public class func prettyDataWithJSONObject(obj: AnyObject) -> NSData {
        do {
            return try NSJSONSerialization.dataWithJSONObject(obj, options: .PrettyPrinted)
            
        } catch {
            return NSData()
        }
    }
    
    public class func JSONObjectWithData(data: NSData) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            
        } catch {
            return nil
        }
    }
}

class DocumentSerializer : NSJSONSerialization {
    class func getData(document: Document) -> NSData {
        return NSJSONSerialization.dataWithJSONObject(DocumentSerializer.getJSONObject(document))
        
    }
    
    class func getJSONObject(document: Document) -> AnyObject {
        var documentJSONObject = [ String : AnyObject ]()
        if document.hasAttachments() {
            documentJSONObject["_attachments"] = document.attachments
        }
        documentJSONObject["hidden"] = 0
        return documentJSONObject
    }
}

class CardSerializer : DocumentSerializer {
    
    override class func getJSONObject(card : Document) -> AnyObject {
        var document = super.getJSONObject(card) as! [ String : AnyObject ]
        document["card"] =  [
                                "type":(card as! Card).type.rawValue,
                                "info":(card as! Card).info,
                                "postDates": (card as! Card).postDateStrings(),
                                "space":[
                                    "topLeftCorner":(card as! Card).space.topLeftCorner,
                                    "width":(card as! Card).space.width,
                                    "height":(card as! Card).space.height
                                ]
                            ]
        return document
    }
    
    override class func getData(card: Document) -> NSData {
        return NSJSONSerialization.dataWithJSONObject(CardSerializer.getJSONObject(card))
    }
}

enum QuerySortDirection : String {
    case Ascending = "asc"
    case Descending = "desc"
}



class Query : NSObject {
    
    private var selector = [String : [String : AnyObject]]()
    private var fields = [ String ]()
    private var sort = [[String : String]]()
    private var limit = 25
    
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

extension NSDate {
    
    func shortDateString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d-M-y"
        return formatter.stringFromDate(self)
    }
    
}

extension String {
    
    func dateFromShortString() -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d-M-y"
        return formatter.dateFromString(self)!
    }
    
}

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

//class AllPostsQuery : Query {
//    
//    override init() {
//        super.init()
//        
//        self.addSelector("_id", comparator: "$gt", value: 0)
//        self.addField("card")
//        self.addSortingParameter("_id", direction: .Ascending)
//    }
//}

class QuerySerializer : NSJSONSerialization {
    
    class func getData(query: Query) -> NSData {
        let query =
                    [
                        "selector":query.selector,
                        "fields":query.fields,
                        "sort":query.sort,
                        "limit":query.limit
                    ]
        
        return NSJSONSerialization.dataWithJSONObject(query)
    }
    
}

extension NSData {
    
    func base64EncodedString() -> String {
        return self.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
}

class Document : NSObject {
    var id : String!
    var revision : String!
    var infoKey : String!
    var info = [String : AnyObject]()
    private var attachments = [ String : [ String : AnyObject ] ]()
    
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

class QueryDeserializer : NSJSONSerialization {
    
    class func getDocuments(data: NSData) -> [Document] {
        let JSONdocuments = (NSJSONSerialization.JSONObjectWithData(data) as! [ String : [ AnyObject ] ])["docs"]!
        var objectDocuments = [Document]()
        for document in JSONdocuments {
            objectDocuments.append(Document(dictionary: document as! [String : AnyObject]))
        }
        
        return objectDocuments
    }
    
}

class DocumentToCardConverter {
    
    class func getCards(documents: [Document]) -> [Card] {
        var cards = [Card]()
        for document in documents {
            cards.append(Card(document: document))
        }
        
        return cards
    }
}

class DelegateProxy : NSObject, NSURLSessionTaskDelegate {
    
    private var delegate : NSURLSessionTaskDelegate?
    
    func forwardMessagesTo(obj: NSURLSessionTaskDelegate?) {
        guard let object = obj else { return }
        delegate = object
    }
    
    override init() {
        super.init()
        
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let forwardedObject = delegate else { return }
        
        // TODO: Figure out the above method signatures
//        if forwardedObject.respondsToSelector()
        
        forwardedObject.URLSession!(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
        
    }
    
}

public class ServerInterface {
    
    static let serverURL = "https://b66668a3-bd4d-4e32-88cc-eb1e0bff350b-bluemix.cloudant.com/ibmboard"
    static let currentSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: DelegateProxy(), delegateQueue: nil)
    static let delegateProxy = currentSession.delegate as! DelegateProxy
    
    static func requestWithURL(url: NSURL) -> NSMutableURLRequest {
        return NSMutableURLRequest(URL: url)
    }
    
    static func requestWithURLString(string: String) -> NSMutableURLRequest {
        let request = requestWithURL(NSURL(string: string)!)
        return request
    }
    
    static func JSONRequestWithURLString(string: String) -> NSMutableURLRequest {
        let request = requestWithURLString(string)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    static func postJSONRequestWithURLString(string: String) -> NSMutableURLRequest {
        let request = JSONRequestWithURLString(string)
        request.HTTPMethod = "POST"
        return request
    }
    
    static func getJSONRequestWithURLString(string: String) -> NSMutableURLRequest {
        return JSONRequestWithURLString(string)
    }
    
    static func putJSONRequestWithURLString(string: String) -> NSMutableURLRequest {
        let request = JSONRequestWithURLString(string)
        request.HTTPMethod = "PUT"
        return request
    }
    
    static func deleteJSONRequestWithURLString(string: String) -> NSMutableURLRequest {
        let request = JSONRequestWithURLString(string)
        request.HTTPMethod = "DELETE"
        return request
    }
    
//    static func doQuery(query : Query) {
//        NSURLSession.sharedSession().dataTaskWithRequest(postJSONRequestWithURLString("\(serverURL)/"), completionHandler: { (data, response, error) in
//            
//            let result = String(data: data!, encoding: NSUTF8StringEncoding)!
//            
//        }).resume()
//    }
    
    static func postCard(cardContent: Card, completion: ((Void) -> Void)?) {
        let request = postJSONRequestWithURLString("\(serverURL)/")
        request.HTTPBody = CardSerializer.getData(cardContent)
        
        ServerInterface.currentSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
            
                let result = String(data: data!, encoding: NSUTF8StringEncoding)!
                guard let handler = completion else { return }
                handler()
            
            })
            
        }).resume()
        
    }
    
    static func deleteCard(cardContent: Card, completion: ((Void) -> Void)) {
        let urlString = "\(serverURL)/\(cardContent.id)?rev=\(cardContent.revision)"
        
        ServerInterface.currentSession.dataTaskWithRequest(deleteJSONRequestWithURLString(urlString), completionHandler: { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                completion()
            })
        }).resume()
    }
    
    static func getPostsFromDate(firstDate : NSDate, toDate secondDate : NSDate, completion: (cards: [Card]) -> Void) {
        let request = postJSONRequestWithURLString("\(serverURL)/_find")
        request.HTTPBody = QuerySerializer.getData(PostsForDateInterval(fromDate: firstDate, toDate: secondDate))
        
        ServerInterface.currentSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                // TODO: Fix random crash that occurs when data is nil
                let result = String(data: data!, encoding: NSUTF8StringEncoding)!
                if data == nil {
                    
                }
                completion(cards: DocumentToCardConverter.getCards((QueryDeserializer.getDocuments(data!))))
            })
        }).resume()
    }
    
    static func getPostsUntilDate(date: NSDate, completion: (cards: [Card]) -> Void) {
        ServerInterface.getPostsFromDate(NSDate(), toDate: date, completion: completion)
    }
    
    static func getAllPostsForToday(completion: (cards: [Card]) -> Void) {
        ServerInterface.getPostsFromDate(NSDate(), toDate: NSDate(), completion: completion)
    }
}