//
//  ArticleParser.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class ArticleParser : NSXMLParser, NSXMLParserDelegate {
    
    var accumulatedTextBody = String()
    
    init?(contentsOfURL url: NSURL) {
        super.init(data: NSData(contentsOfURL: url)!)
        self.delegate = self
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
    
        
        
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if(attributeDict["class"]?.localizedCompare("zn-body__paragraph").rawValue == 1) {
            print("")
        }
        
        if(isParagraphElement(elementName)) {
            print(attributeDict)
        }
        
    }
    
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("")
    }

    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print("")
    }
    
    func isParagraphElement(let element: String) -> Bool {
        return element.lowercaseString == "p" || element.lowercaseString == "div"
    }
    
}
