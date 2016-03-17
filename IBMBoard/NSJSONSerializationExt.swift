//
//  NSJSONSerializationExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
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