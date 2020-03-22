//
//  ViewController.swift
//  RGBConrol
//
//  Created by Andrew Zinoviev on 3/21/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit
import RGBDriver
import PlainPing

class ViewController: UIViewController{
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var valueSlider: UISlider!
    
    var strip: WirelessRGBStrip?
    public var host: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let host = host{
            strip = WirelessRGBStrip(host: host, ledsCount: 181)
            title = host
            update()
        }
    }
    
    @IBAction func onHueSliderChanges(_ sender: Any) {
        update()
    }
    
    @IBAction func onValueSliderChanges(_ sender: Any) {
        update()
    }
    
    private func update(){
        let hue: CGFloat = CGFloat(hueSlider!.value)
        let val: CGFloat = CGFloat(valueSlider!.value)
        let color = UIColor(hue: hue, saturation: 1.0, brightness: val, alpha: 1.0)
        
        colorView.backgroundColor = color
        strip?.fill(color: color)
    }
    
}

