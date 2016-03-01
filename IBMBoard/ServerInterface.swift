//
//  ServerInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

public class ServerInterface {
    
    public static func postVideo(let videoURL: String, let videoTitle: String, let completion: ((Void) -> Void)?) {
        
        
        
    }
    
    public static func postArticle(let articleURL: String, let articleTitle: String, let completion: ((Void) -> Void)?) {
        
        
        
    }
    
    public static func postAnnouncement(let bodyText: String, let completion: ((Void) -> Void)?) {
        
        
        
    }
    
    public static func getAllPostsForToday() -> [AnyObject]? {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:"https://b66668a3-bd4d-4e32-88cc-eb1e0bff350b-bluemix.cloudant.com/ibmboard/_all_docs")!, completionHandler: { (data, response, error) in
            
                let result = String(data: data!, encoding: NSUTF8StringEncoding)!
            }).resume()
        
        return nil
    }
}