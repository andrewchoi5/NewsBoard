//
//  VideoAPIManager.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-04.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class VideoAPIManager {
    
    static let videoIDMarker = "{{VIDEO_IDENTIFIER}}"
    
    static let videoPreviewAPIURLs = [
        
        "youtube":"http://img.youtube.com/vi/\(videoIDMarker)/0.jpg"
    ]
    
    static func getAPIURLStringTemplate(videoURLDomain: String) -> String {
        return videoPreviewAPIURLs[videoURLDomain]!
    }
    
    static func getAPIURLString(videoURLDomain: String, videoCode: String) -> String {
        var urlTemplate = getAPIURLStringTemplate(videoURLDomain)
        urlTemplate.replaceRange(urlTemplate.rangeOfString(VideoAPIManager.videoIDMarker)!, with: videoCode)
        return urlTemplate
        
    }
    
    static func getAPIURL(urlString: String) -> NSURL {
        let trimmedString = urlString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        guard let sanitizedURL = NSURL(string: trimmedString) else { return NSURL() }
        guard let sanitizedHost = sanitizedURL.host else { return NSURL() }
        guard let sanitizedQuery = sanitizedURL.query else { return NSURL() }
        if(sanitizedHost.containsString("youtube")) {
            let videoCode = getQueryStringDictionary(sanitizedQuery)["v"]
            return NSURL(string: getAPIURLString("youtube", videoCode: videoCode!))!
        }
        return NSURL()
    }
    
    static func getQueryStringDictionary(queryString : String) -> Dictionary<String,String> {
        var queryDictionary = Dictionary<String,String>()
        let queries = queryString.componentsSeparatedByString("&")
        for query in queries {
            let queryName = query.componentsSeparatedByString("=")[0]
            let queryValue = query.componentsSeparatedByString("=")[1]
            queryDictionary[ queryName ] = queryValue
        }
        return queryDictionary
    }
    
}