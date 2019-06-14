//
//  Number+Utilities.swift
//  My Math Helper
//
//  Created by Héctor García Peña on 5/25/19.
//  © 2019 Grio All rights reserved.
//

import Foundation

public extension Float {
    
    /// Assumes this quantity is in radians so it converts it to degrees
    var degrees : Float {
        return self * 180.0 / .pi
    }
    
    /// Assumes this quantity is in defrees so it converts it to radians
    var radians : Float {
        return self * .pi / 180.0
    }
}

public extension CGFloat {
    
    /// Assumes this quantity is in radians so it converts it to degrees
    var degrees : CGFloat {
        return self * 180.0 / .pi
    }
    
    /// Assumes this quantity is in defrees so it converts it to radians
    var radians : CGFloat {
        return self * .pi / 180.0
    }
}

public extension Double {
    
    /// Assumes this quantity is in radians so it converts it to degrees
    var degrees : Double {
        return self * 180.0 / .pi
    }
    
    /// Assumes this quantity is in defrees so it converts it to radians
    var radians : Double {
        return self * .pi / 180.0
    }
}
