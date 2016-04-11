//
//  BoardViewController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-06.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class BoardViewController : UIViewController {
    
    var gradientBackgroundStartColor = UIColor(red: 193.0 / 255.0, green: 225.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    var gradientBackgroundEndColor = UIColor(red: 249.0 / 255.0, green: 251.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)

    var backgroundLayer : CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addGradientBackground()
    }
    
    func addGradientBackground() {
        backgroundLayer = CAGradientLayer()
        backgroundLayer.colors = [gradientBackgroundStartColor.CGColor, gradientBackgroundEndColor.CGColor]
        self.view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    func reverseBackgroundGradient() {
        backgroundLayer.colors = backgroundLayer.colors?.reverse()
        self.view.setNeedsLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundLayer.frame = self.view.bounds
    }
    
}