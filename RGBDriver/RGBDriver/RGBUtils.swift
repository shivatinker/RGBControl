//
//  RGBUtils.swift
//  RGBDriver
//
//  Created by Andrew Zinoviev on 3/21/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit.UIColor

class RGBUtils {
    static let PACKET_ALL_START: UInt8 = 0x01
    
    static func createAllLedsPacket(leds: Array<UIColor>) -> Data{
        var bytes = [UInt8]()
        bytes.append(PACKET_ALL_START)
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        for color in leds{
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            bytes.append((UInt8) (0xFF * r))
            bytes.append((UInt8) (0xFF * g))
            bytes.append((UInt8) (0xFF * b))
        }
        var crc: UInt32 = 0;
        for b in bytes{
            crc = (crc + UInt32(b)) % (0x100)
        }
        bytes.append(UInt8(crc))
        return Data(bytes)
    }
    

}
