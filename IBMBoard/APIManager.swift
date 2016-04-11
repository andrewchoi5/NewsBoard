//
//  APIManager.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation


public class APIManager {
    
    public static var indent = 0
    public static let maxTagScans = 100000
    public static var totalTagScans = 0
    public static var collectedTitle = "Testing Article Title"
    public static let noPreviewText = "Could not generate preview of article"
    
    public static var container = Set<String>()
    
    public static let classValueNameFragments = [
                                                    "editorial",
                                                    "body",
                                                    "source"
    ]
    
    public static func getArbitraryVideoTitle(videoURLString: String, maxLength: UInt) -> String {
        if videoURLString == "" {
            return ""
        }
        
        guard let url = NSURL(string: videoURLString) else { return "" }
        guard let urlContentsData = NSData(contentsOfURL: url)  else { return "" }
        guard let contentsString = String(data: urlContentsData, encoding: NSUTF8StringEncoding) else { return "" }
        
        contentsString.stringByReplacingOccurrencesOfString("<html>", withString: "<html xmlns='http://www.w3.org/1999/xhtml'>")
        
        let parsedXML = TBXML(XMLString: contentsString)
        
        return APIManager.collectVideoTitle(parsedXML.rootXMLElement)
    }
    
    public static func getArbitraryTextArticleTitle() -> String {
        return collectedTitle
    }
    
    public static func getArbitraryTextArticlePreview(articleURLString: String) -> String {
//        let parser = ArticleParser(contentsOfURL: NSURL(string: articleURL)!)!
//        parser.parse()
        if articleURL == "" {
            return noPreviewText
        }
        
        guard let url = NSURL(string: articleURLString) else { return "" }
        guard let urlContentsData = NSData(contentsOfURL: url)  else { return "" }
        guard let contentsString = String(data: urlContentsData, encoding: NSUTF8StringEncoding) else { return "" }
        
        contentsString.stringByReplacingOccurrencesOfString("<html>", withString: "<html xmlns='http://www.w3.org/1999/xhtml'>")
//        string = string?.stringByReplacingOccurrencesOfString("/>", withString: ">")
        
//        let encodedData = NSData(contentsOfURL: NSURL(string: articleURL)!)!
//        let attributedOptions : [String: AnyObject] = [
//            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
//        ]
//        var attributedString : NSAttributedString = NSAttributedString()
//        do {
//            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
//        
//        } catch {
//            
//        }
//
//        print(attributedString)
        
        var parsedXML = TBXML(XMLString: contentsString)
        var previewText = APIManager.collectPreviewArticleText(parsedXML.rootXMLElement)
        if(previewText == "") {
            previewText = noPreviewText
        }
        parsedXML = nil;
        totalTagScans = 0
        
        return previewText
    }

    static func generateSpaces(spacesNumber : Int) -> String {
        var spaces = ""
        for var i = spacesNumber; i >= 0; i -= 1 {
            spaces += " "
        }
        return spaces
    }
    
    // TBXML has difficulty interpreting self-terminating html tags
    
    static func probablyContainsUsefulText(classValue : String) -> Bool {
        for fragment in classValueNameFragments {
            if(classValue.containsString(fragment)) {
                return true
            }
        }
        return false
    }
    
    static func collectVideoTitle(element : UnsafeMutablePointer<TBXMLElement>) -> String {
        
        if(element == nil ) {
            return ""
            
        }
        
        var collectedTitle = ""
        
        if TBXML.elementName(element) == "title" {
            return TBXML.textForElement(element)
        }
        
        collectedTitle = self.collectVideoTitle(element.memory.firstChild)
        if(collectedTitle != "") {
            return collectedTitle
        }
        
        var nextSibling = element.memory.nextSibling
        
        while (nextSibling != nil) {
            collectedTitle = self.collectVideoTitle(nextSibling)
            if(collectedTitle != "") {
                return collectedTitle
            }
            nextSibling = nextSibling.memory.nextSibling
        }
        
        return collectedTitle
    }
    
    static func collectPreviewArticleText(element : UnsafeMutablePointer<TBXMLElement>) -> String {
        if(element == nil || totalTagScans >= maxTagScans) {
            return ""
            
        }
        
//        ++totalTagScans
        
        var collectedText = ""
        
//        if(element.memory.firstAttribute != nil && element.memory.firstAttribute.memory.next != nil) {
//            let attributeName = TBXML.attributeName(element.memory.firstAttribute.memory.next)
//            let attributeValue = TBXML.attributeValue(element.memory.firstAttribute.memory.next)
//            let string = "\(APIManager.generateSpaces(indent))<\(TBXML.elementName(element)) \(attributeName)='\(attributeValue)'>"
//            print(string)
//            if !container.contains(string) {
//                container.insert(string)
//            } else {
//                print("")
//            }
//            
//            
//        } else {
//            let string = "\(APIManager.generateSpaces(indent))<\(TBXML.elementName(element))>"
//            print(string)
//            if !container.contains(string) {
//                container.insert(string)
//            } else {
//                print("")
//            }
//
//        }
        
        if TBXML.elementName(element) == "title" {
            collectedTitle = TBXML.textForElement(element)
        }
        
        if TBXML.elementName(element) == "p" || TBXML.elementName(element) == "cite" {
//            if let classValue = TBXML.valueOfAttributeNamed("class", forElement: element) {
//                if(APIManager.probablyContainsUsefulText(classValue)) {
                    collectedText += TBXML.textForElement(element)
                    
//                }
//                
//            } else {
//                collectedText += TBXML.textForElement(element)
                
//            }
        }
        
        APIManager.indent += 1
        collectedText += self.collectPreviewArticleText(element.memory.firstChild)
        APIManager.indent -= 1
        
        var nextSibling = element
        
        while (nextSibling != nil) {
            collectedText += self.collectPreviewArticleText(nextSibling.memory.firstChild)
//            collectedText += self.collectPreviewArticleText(nextSibling)
            nextSibling = nextSibling.memory.nextSibling
        }
        
        return collectedText
    }
    
}