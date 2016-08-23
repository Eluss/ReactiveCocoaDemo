//
//  UIColorExtension.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    static func demoTextColor() -> UIColor {
        return UIColor(hex: 0x270722)
    }
    
    static func demoLightBackgroundColor() -> UIColor {
        return UIColor(hex: 0xC2C6A7)
    }
    
    static func demoBackgroundColor() -> UIColor {
        return UIColor(hex: 0xECCE8E)
    }
    
    static func demoAlertColor() -> UIColor {
        return UIColor(hex: 0xD7263D)
    }
}
