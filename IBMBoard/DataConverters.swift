//
//  Serializers.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

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
