//
//  Serializers.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class CouchDBSerializer : NSObject {
    class func getData(document: Document) -> NSData {
        return NSJSONSerialization.dataWithJSONObject(CouchDBSerializer.getJSONObject(document))
        
    }
    
    class func getJSONObject(document: Document) -> AnyObject {
        var documentJSONDict = DocumentSerializer.getDocumentJSONDict(document)
        if document is Card {
            documentJSONDict["card"] = CardSerializer.getCardJSONDict(document as! Card)
            
        }
        
        if document is Account {
            documentJSONDict["account"] =  AccountSerializer.getAccountJSONDict(document as! Account)

        }

        return documentJSONDict
    }
}

class DocumentSerializer : NSObject {
    class func getDocumentJSONDict(document : Document) -> [ String : AnyObject ] {
        var documentJSONDict = [ String : AnyObject ]()
        if document.hasAttachments() {
            documentJSONDict["_attachments"] = document.attachments
            
        }
        documentJSONDict["hidden"] = 0
        if let id = document.id {
            documentJSONDict["_id"] = id
            
        }
        if let revision = document.revision {
            documentJSONDict["_rev"] = revision
            
        }
        
        return documentJSONDict
    }
    

}

class CardSerializer : NSObject {
    
    class func getCardJSONDict(card : Card) -> [String : AnyObject] {
        return [
            "type":card.type.rawValue,
            "info":card.info,
            "postDates": card.postDateStrings(),
            "space":[
                "topLeftCorner":card.space.topLeftCorner,
                "width":card.space.width,
                "height":card.space.height
            ]
        ]
    }
    
}

class AccountSerializer : NSObject {
    
    class func getAccountJSONDict(account : Account) -> [String : AnyObject] {
        return [
            "email":account.email,
            "password":account.password,
            "verificationCode":account.verificationCode,
            "verified":account.verified,
        ]
    }
    
}

class QueryDeserializer {
    
    class func getDocuments(data: NSData) -> [Document] {
        let JSONdocuments = (NSJSONSerialization.JSONObjectWithData(data) as! [ String : [ AnyObject ] ])["docs"]!
        var objectDocuments = [Document]()
        for document in JSONdocuments {
            objectDocuments.append(Document(dictionary: document as! [String : AnyObject]))
        }
        
        return objectDocuments
    }
    
}

class ServerResponseDeserializer {
    
    class func getResponse(data: NSData) -> ServerResponse {
        guard let responseDict = NSJSONSerialization.JSONObjectWithData(data) as? [ String : AnyObject ] else {
            return NullServerResponse()
        }
        
        return ServerResponse(withDictionary: responseDict)
        
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

class DocumentToAccountConverter {
    
    class func getAccounts(documents: [Document]) -> [Account] {
        var cards = [Account]()
        for document in documents {
            cards.append(Account(document: document))
        }
        
        return cards
    }
}

class QuerySerializer {
    
    class func getData(query: Query) -> NSData {
        let query =
        [
            "selector":query.selectors,
            "fields":query.fields,
            "sort":query.sort,
            "limit":query.limit
        ]
        
        return NSJSONSerialization.dataWithJSONObject(query)
    }
    
}
