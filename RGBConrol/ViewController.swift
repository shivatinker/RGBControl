//
//  ViewController.swift
//  RGBConrol
//
//  Created by Andrew Zinoviev on 3/21/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import RGBDriver

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var d = RGBDriver()
        print(d.answer());
    }


}

