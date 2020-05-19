//
//  ViewController.swift
//  swiftText
//
//  Created by 景军 on 2017/11/23.
//  Copyright © 2017年 景军. All rights reserved.
//

import UIKit

//extension UIColor {
//    
//    /**
//     Create non-autoreleased color with in the given hex string and alpha.
//     
//     - parameter hexString: The hex string, with or without the hash character.
//     - parameter alpha: The alpha value, a floating value between 0 and 1.
//     - returns: A color with the given hex string and alpha.
//     */
//    convenience init?(hexString: String, alpha: Float = 1.0) {
//        var hex = hexString
//        
//        // Check for hash and remove the hash
//        if hex.hasPrefix("#") {
//            hex = hex.substring(from: 1, to: hex.count)
//        }
//        
//        if (hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil) {
//            
//            // Deal with 3 character Hex strings
//            if hex.count == 3 {
//                let redHex   = hex.ncf.substring(from: 0, to: 1)
//                let greenHex = hex.ncf.substring(from: 1, to: 2)
//                let blueHex  = hex.ncf.substring(from: 2, to: 3)
//                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
//            }
//            
//            let redHex   = hex.ncf.substring(from: 0, to: 2)
//            let greenHex = hex.ncf.substring(from: 2, to: 4)
//            let blueHex  = hex.ncf.substring(from: 4, to: 6)
//            
//            var redInt:   CUnsignedInt = 0
//            var greenInt: CUnsignedInt = 0
//            var blueInt:  CUnsignedInt = 0
//            
//            Scanner(string: redHex).scanHexInt32(&redInt)
//            Scanner(string: greenHex).scanHexInt32(&greenInt)
//            Scanner(string: blueHex).scanHexInt32(&blueInt)
//            
//            if #available(iOS 10.0, *) {
//                self.init(displayP3Red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
//            } else {
//                // Fallback on earlier versions
//                self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
//            }
//            
//        } else {
//            // Note:
//            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
//            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
//            // in future releases, not a feature. -- Apple Forum
//            self.init()
//            return nil
//        }
//    }
//    
//    /**
//     Create non-autoreleased color with in the given hex value and alpha
//     
//     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
//     - parameter alpha: The alpha value, a floating value between 0 and 1.
//     - returns: color with the given hex value and alpha
//     */
//    convenience init?(hex: Int, alpha: Float = 1.0) {
//        var hexString = String(format: "%2X", hex)
//        let leadingZerosString = String(repeating: "0", count: 6 - hexString.count)
//        hexString = leadingZerosString + hexString
//        self.init(hexString: hexString, alpha: alpha)
//        
//    }
//    
//}

