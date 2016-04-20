//
//  ServerInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import SystemConfiguration

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
    
    // Credentials
    static let APIKey = "llyespecietwersimartayth"
    static let APIPassword = "26acdf29a791400f22b4e3e7df556d52eda31f82"
    static let APIHost = "b66668a3-bd4d-4e32-88cc-eb1e0bff350b-bluemix.cloudant.com"
    static let APIRealm = "Cloudant Private Database"
    
    // Network Layer Specifics
    static let APIPort = 443
    static let APIProtocol = NSURLProtectionSpaceHTTPS
    static let APIAuthenticationMethod = NSURLAuthenticationMethodHTTPBasic
    
    static let defaultEmailSender = "ibmboard@gmail.com"
    static let defaultEmailServer = "smtp.gmail.com"
    static let defaultEmailPassword = "dsjhdsjhadsjh"
    
    static let serverURL = "https://b66668a3-bd4d-4e32-88cc-eb1e0bff350b-bluemix.cloudant.com"
    
    static let currentSession = NSURLSession(configuration: ServerInterface.sessionConfiguration(), delegate: DelegateProxy(), delegateQueue: NSOperationQueue.mainQueue())
    static let delegateProxy = currentSession.delegate as! DelegateProxy
    
    // NOTE: Method must be called before any attempt to connect to server
    static func initializeCredentials() {
        NSURLCredentialStorage.sharedCredentialStorage().setCredential(NSURLCredential(user: APIKey, password: APIPassword, persistence: .ForSession), forProtectionSpace: NSURLProtectionSpace(host: APIHost, port: APIPort, protocol: APIProtocol, realm: APIRealm, authenticationMethod: APIAuthenticationMethod))
    }
    
    static func sessionConfiguration() -> NSURLSessionConfiguration {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 120.0
        config.timeoutIntervalForResource = 120.0
        return config
    }
    
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
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

struct DocumentMetaData {
    
    var id : String!
    var revision : String!
    
    init(withDictionary dictionary: [ String : AnyObject ]) {
        id = dictionary["id"] as! String
        revision = dictionary["rev"] as! String
        
    }
}

class NullServerResponse : ServerResponse {
    override var wasSuccessful: Bool {
        return false
    }
    
    
    override init() {
        super.init()
        
        documentMetaData = nil
        info = [ String : AnyObject ]()
    }
    
}

class ServerResponse : NSObject {
    
    var wasSuccessful : Bool {
        return info[ "ok" ] as! Bool
    }
    
    var documentMetaData : DocumentMetaData?
    var info : [ String : AnyObject ]!
    
    init(withDictionary dictionary: [ String : AnyObject ]) {
        super.init()
        
        info = dictionary
        documentMetaData = DocumentMetaData(withDictionary: dictionary)
    }
    
    override init() {
        super.init()
        
    }
}

extension ServerInterface {
    
    static func addDocument(document: Document, toDatabase dbName: String, completion: ((Void) -> Void)?) {
        let request = postJSONRequestWithURLString("\(serverURL)/\(dbName)")
        request.HTTPBody = CouchDBSerializer.getData(document)
        
        ServerInterface.currentSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            guard let responseData = data else { return }
            guard let handler = completion else { return }
            guard let metaData = ServerResponseDeserializer.getResponse(responseData).documentMetaData else {
                handler()
                return
            }
            document.updateWithDocumentMetaData(metaData)
            handler()
            
        }).resume()
    }
    
    static func getDocuments(withQuery query : Query, inDatabase dbName: String, completion : ([ Document ]) -> Void) {
        
        let request = postJSONRequestWithURLString("\(serverURL)/\(dbName)/_find")
        request.HTTPBody = QuerySerializer.getData(query)
        
        ServerInterface.currentSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            guard let responseData = data else { return }
//            let result = String(data: responseData, encoding: NSUTF8StringEncoding)!
            
            completion(QueryDeserializer.getDocuments(responseData))
        }).resume()
        
    }
    
    static func updateDocumentWithMetaData(document: Document, inDatabase dbName: String, completion: ((Void) -> Void)?) {
        let request = putJSONRequestWithURLString("\(serverURL)/\(dbName)/\(document.id)")
        request.HTTPBody = CouchDBSerializer.getData(document)
        
        ServerInterface.currentSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            guard let responseData = data else { return }
            guard let handler = completion else { return }
            guard let metaData = ServerResponseDeserializer.getResponse(responseData).documentMetaData else {
                handler()
                return
            }
            document.updateWithDocumentMetaData(metaData)
            handler()
            
        }).resume()
    }
    
    static func updateDocumentWithNoMetaData(document: Document, inDatabase dbName: String, completion: ((Void) -> Void)?) {
        ServerInterface.updateDocumentWithMetaData(document, inDatabase: dbName, completion: completion)
        
    }
    
    static func updateDocument(document: Document, inDatabase dbName: String, completion: ((Void) -> Void)?) {
        if document.hasNoMetaData() {
            ServerInterface.updateDocumentWithNoMetaData(document, inDatabase: dbName, completion: completion)
            
        } else {
            ServerInterface.updateDocumentWithMetaData(document, inDatabase: dbName, completion: completion)
            
        }
    }
    
    static func deleteDocument(document: Document, inDatabase dbName: String, completion: ((Void) -> Void)?) {
        let urlString = "\(serverURL)/\(dbName)/\(document.id)?rev=\(document.revision)"
        
        ServerInterface.currentSession.dataTaskWithRequest(deleteJSONRequestWithURLString(urlString), completionHandler: { (data, response, error) in
            guard let handler = completion else { return }
            handler()
        
        }).resume()
    }
}

extension ServerInterface {
    static func addCard(card: Card, completion: ((Void) -> Void)?) {
        ServerInterface.addDocument(card, toDatabase: "ibmboard", completion: completion)
        
    }
    
    static func deleteCard(card: Card, completion: ((Void) -> Void)?) {
        ServerInterface.deleteDocument(card, inDatabase: "ibmboard", completion: completion)
        
    }
    
    static func getCards(fromDate firstDate : NSDate, toDate secondDate : NSDate, completion: ([Card]) -> Void) {
        ServerInterface.getDocuments(withQuery: CardQuery(withStartingDate: firstDate, toEndingDate: secondDate),inDatabase: "ibmboard") { (documents) in
            completion(DocumentToCardConverter.getCards(documents))
            
        }
        
    }
    
    static func getCards(untilDate date: NSDate, completion: (cards: [Card]) -> Void) {
        ServerInterface.getCards(fromDate: NSDate(), toDate: date, completion: completion)
        
    }
    
    static func getCardsForToday(completion: (cards: [Card]) -> Void) {
        ServerInterface.getCards(fromDate: NSDate(), toDate: NSDate(), completion: completion)
        
    }
    
}


extension ServerInterface {
    
    static func addAccount(account: Account, completion: ((Void) -> Void)?) {
        ServerInterface.addDocument(account, toDatabase: "accounts", completion: completion)
        
    }
    
    static func updateAccount(account: Account, completion: ((Void) -> Void)?) {
        ServerInterface.updateDocument(account, inDatabase: "accounts", completion: completion)
        
    }
    
    static func getAccounts(withEmail email: String, andPassword password: String, completion: ([ Account ]) -> Void) {
        ServerInterface.getDocuments(withQuery: AccountQuery(withEmail: email, andPassword: password), inDatabase: "accounts") { (documents) in
            completion( DocumentToAccountConverter.getAccounts( documents ) )
            
        }
        
    }
    
    static func getAccounts(withEmail email: String, completion: ([ Account ]) -> Void) {
        ServerInterface.getDocuments(withQuery: AccountQuery(withEmail: email), inDatabase: "accounts") { (documents) in
            completion( DocumentToAccountConverter.getAccounts( documents ) )
            
        }
        
    }
    
    static func getAccount(withEmail email: String, andPassword password: String, completion: ( Account? ) -> Void) {
        ServerInterface.getAccounts(withEmail: email, andPassword: password) { (accounts) in
            completion(accounts.first)
            
        }
        
    }
    
    static func getAccount(withEmail email: String, completion: ( Account? ) -> Void) {
        ServerInterface.getAccounts(withEmail: email) { (accounts) in
            completion(accounts.first)
            
        }
        
    }
    
    static func checkIfEmailExists(withEmail email: String, completion: ((Bool) -> Void)) {
        ServerInterface.getAccount(withEmail: email) { (account) in
            completion( account != nil )
            
        }
        
    }
    
    static func getAccounts(associatedWithCard card: Card!, completion: ( [ Account ] ) -> Void) {
        ServerInterface.getDocuments(withQuery: AccountQuery(withCard: card), inDatabase: "accounts") { (documents) in
            completion( DocumentToAccountConverter.getAccounts( documents ) )
            
        }
        
    }
    
    static func getAccount(associatedWithCard card: Card!, completion: ( Account? ) -> Void) {
        ServerInterface.getAccounts(associatedWithCard: card) { (accounts) in
            completion(accounts.first)
        }
        
    }
}