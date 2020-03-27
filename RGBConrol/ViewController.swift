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
    
    @IBOutlet weak var rainbowSwitch: UISwitch!
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
    
    var rainbowActive = false
    var hue = 0
    @IBAction func onRainbowToggle(_ sender: Any) {
        if(rainbowSwitch.isOn){
            rainbowActive = true
            DispatchQueue.global(qos: .userInitiated).sync {
                let t = Timer.scheduledTimer(withTimeInterval: 1.0 / 75, repeats: true){ timer in
                    if(!self.rainbowActive){
                        timer.invalidate()
                        return
                    }
                    self.strip?.fill(color: UIColor(hue: CGFloat(self.hue) / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0))
                    self.hue = (self.hue + 1) % 360
                }
            }
        }else{
            rainbowActive = false
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

