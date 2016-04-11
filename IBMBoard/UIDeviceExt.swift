//
//  UIDeviceExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-11.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

public func UIDeviceOrientationIsLandscapeOrUnknown(orientation : UIDeviceOrientation) -> Bool {
    return UIDeviceOrientationIsLandscape(orientation) || orientation == .Unknown
}

public func UIDeviceOrientationIsPortraitOrUnknown(orientation : UIDeviceOrientation) -> Bool {
    return UIDeviceOrientationIsPortrait(orientation) || orientation == .Unknown
}

extension UIDevice {
    
}