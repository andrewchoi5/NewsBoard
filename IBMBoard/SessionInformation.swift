//
//  SessionInformation.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-06.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

enum UserRole {
    
    case Default
    case Admin
    
}

class SessionInformation : NSObject {
    
    static let currentSession = SessionInformation()
    
    var userAccount : Account!
    var userRole : UserRole!
    
    func hasAdminRights() -> Bool {
        
        return userRole == .Admin
        
    }
    
    override init() {
        super.init()
        
        userRole = .Default
        
    }
    
}