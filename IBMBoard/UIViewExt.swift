//
//  UIViewExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-12.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func constraintWithID(ID: String) -> NSLayoutConstraint? {
        if ID == "" {
            return nil
        }
        
        for constraint in constraints {
            if constraint.identifier == ID {
                return constraint
            }
        }
        
        return nil
    }
    
}