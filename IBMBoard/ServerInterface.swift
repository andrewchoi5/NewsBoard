//
//  ServerInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

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
//                guard let responseData = data else { return }
//                let result = String(data: responseData, encoding: NSUTF8StringEncoding)!
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
                guard let responseData = data else { return }
//                let result = String(data: responseData, encoding: NSUTF8StringEncoding)!
                completion(cards: DocumentToCardConverter.getCards((QueryDeserializer.getDocuments(responseData))))
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