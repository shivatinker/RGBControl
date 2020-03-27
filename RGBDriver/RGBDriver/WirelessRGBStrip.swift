//
//  WirelessRGBStrip.swift
//  RGBDriver
//
//  Created by Andrew Zinoviev on 3/21/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import PlainPing

public class WirelessRGBStrip: NSObject, RGBDevice, GCDAsyncUdpSocketDelegate {
    
    // Static
    
    public var ledsCount: Int
    var host: String
    let port: UInt16 = 56441
    
    var mSocket: GCDAsyncUdpSocket!

    enum State {
        case ready
        case sendingData
    }
    
    var state = State.ready
    
    private func sendPacket(_ data: Data){
        if(state != .ready){
            return
        }
        mSocket.setDelegate(self)
        mSocket.send(data, toHost: host, port: port, withTimeout: 0.5, tag: 1)
        state = .sendingData
    }
    
    public func fill(color: UIColor){
        //sendPacket(RGBUtils.createFillPacket(color: color))
        sendPacket(RGBUtils.createAllLedsPacket(leds: Array(repeating: color, count: ledsCount)))
    }
    
    public func setLeds(colors: [UIColor]) {
        sendPacket(RGBUtils.createAllLedsPacket(leds: colors))
    }
    
    public init(host: String, ledsCount: Int) {
        self.ledsCount = ledsCount
        self.host = host
        mSocket = GCDAsyncUdpSocket(delegate: nil, delegateQueue: DispatchQueue.global(qos: .userInitiated))
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        //print("Data sent.")
        state = .ready
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print(error)
        state = .ready
    }
}
