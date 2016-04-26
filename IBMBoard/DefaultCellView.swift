//
//  DefaultCellView.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class DefaultCellView : UICollectionViewCell {
    
    // when each flag is set to false, the rectangle takes up the full cell
    // when for example, the top flag is set to true, then top top of the rect will be empty
    func drawCellRect(leftEmpty : Bool, topEmpty: Bool, rightEmpty : Bool, bottomEmpty : Bool) {
        let greyBox = UIView()
//        greyBox.backgroundColor = UIColor.redColor()
        greyBox.frame.origin = CGPointZero
        greyBox.frame.size.width = self.frame.size.width
        greyBox.frame.size.height = self.frame.size.height
        self.contentView.addSubview(greyBox)
    }
    
}