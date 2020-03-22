//
//  RGBDevice.swift
//  RGBDriver
//
//  Created by Andrew Zinoviev on 3/21/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation
import UIKit.UIColor

public protocol RGBDevice{
    var ledsCount: Int {get}
    
    func connect()
    func disconnect()
    
    func fill(color: UIColor)
    func setLeds(colors: [UIColor])
}
