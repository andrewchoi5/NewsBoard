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

class CardSerializer : NSJSONSerialization {
    
    class func getData(card: Card) -> NSData {
        let card = [
            "card" : [
                "type":card.type.rawValue,
                "info":card.info,
                "space":[
                    "topLeftCorner":card.space.topLeftCorner,
                    "width":card.space.width,
                    "height":card.space.height
                ]
            ]
        ]
        
        return NSJSONSerialization.dataWithJSONObject(card)
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
    
    override init() {
        super.init()
        
        self.addField("_id")
        self.addField("_rev")

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
    
}

class AllPostsQuery : Query {
    
    override init() {
        super.init()
        
        self.addSelector("_id", comparator: "$gt", value: 0)
        self.addField("card")
        self.addSortingParameter("_id", direction: .Ascending)
    }
}

class QuerySerializer : NSJSONSerialization {
    
    class func getData(query: Query) -> NSData {
        let query =
                    [
                        "selector":query.selector,
                        "fields":query.fields,
                        "sort":query.sort
                    ]
        
        return NSJSONSerialization.dataWithJSONObject(query)
    }
    
}

class Document : NSObject {
    var id : String!
    var revision : String!
    var infoKey : String!
    var info : [String : AnyObject]!
    
    init(dictionary : [ String : AnyObject ]) {
        super.init()
        
        id = dictionary["_id"] as! String
        revision = dictionary["_rev"] as! String
        
        var keys = Set(dictionary.keys)
        keys.remove("_id")
        keys.remove("_rev")
        infoKey = keys.removeFirst()
        
        info = dictionary[ infoKey ] as! [String : AnyObject]
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

class CardToDocumentConverter {
    
    class func getCards(documents: [Document]) -> [Card] {
        var cards = [Card]()
        for document in documents {
            cards.append(Card(dictionary: document.info))
        }
        
        return cards
    }
}

public class ServerInterface {
    
    static let serverURL = "https://b66668a3-bd4d-4e32-88cc-eb1e0bff350b-bluemix.cloudant.com/ibmboard"
    
    static func doPostRequest() {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(serverURL)/")!)
        request.HTTPMethod = "POST"
    }
    
    static func doGetRequest() {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(serverURL)/")!)
        
    }
    
    static func doPutRequest() {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(serverURL)/")!)
        request.HTTPMethod = "PUT"
    }
    
    static func doDeleteRequest() {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(serverURL)/")!)
        request.HTTPMethod = "DELETE"
    }
    
    static func doQuery(query : Query) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(serverURL)/")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = QuerySerializer.getData(query)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:"\(serverURL)/_all_docs")!, completionHandler: { (data, response, error) in
            
            let result = String(data: data!, encoding: NSUTF8StringEncoding)!
            
        }).resume()
    }
    
    static func postCard(cardContent: Card, completion: ((Void) -> Void)?) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(serverURL)/")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = CardSerializer.getData(cardContent)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            let result = String(data: data!, encoding: NSUTF8StringEncoding)!
            
        }).resume()
        
    }
    
    static func getAllPostsForToday(completion: (cards: [Card]) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(serverURL)/_find")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = QuerySerializer.getData(AllPostsQuery())
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                // TODO: Fix random crash that occurs when data is nil
                completion(cards: CardToDocumentConverter.getCards((QueryDeserializer.getDocuments(data!))))
            })
        }).resume()
    }
}