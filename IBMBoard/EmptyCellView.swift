//
//  EmptyCellView.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class EmptyCellView : DefaultCellView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = false
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(red: 50.0 / 255.0, green: 152.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }
    
}