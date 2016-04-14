//
//  PosterController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-03.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class PosterController : KeyboardPresenter {
    
    var selectedCardSpace : Card = Card()

    func finishedCreatingPost() {
        self.performSegueWithIdentifier("backToLoginSegue", sender: self)
        
    }
    
}

class PlaceholderPosterController : PosterController {
    
    
    
}