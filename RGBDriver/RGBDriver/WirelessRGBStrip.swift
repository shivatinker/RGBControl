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

public class WirelessRGBStrip: NSObject, RGBDevice, GCDAsyncSocketDelegate {
    
    // Static
    
    public var ledsCount: Int
    var host: String
    let port: UInt16 = 56441
    
    enum State{
        case disconnected
        case connected
        case connecting
    }
    
    var state = State.disconnected
    
    var mSocket: GCDAsyncSocket!
    
    public func connect() {
        if(state != .disconnected){
            return
        }
        state = .connecting
        mSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
        do{
            try mSocket.connect(toHost: host, onPort: port, withTimeout: 1)
        } catch let e{
            print(e)
        }
        print("Connecting to \(host):\(port)")
    }
    
    public func disconnect() {
        if(state != .disconnected){
            mSocket.disconnect()
        }
    }
    
    public func fill(color: UIColor) {
        setLeds(colors: Array(repeating: color, count: ledsCount))
    }
    
    public func setLeds(colors: [UIColor]) {
        connect()
        mSocket.write(RGBUtils.createAllLedsPacket(leds: colors), withTimeout: -1, tag: 1)
    }
    
    public init(host: String, ledsCount: Int) {
        self.ledsCount = ledsCount
        self.host = host
    }
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("Connected to \(host):\(port)")
        state = .connected
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if let err = err{
            print("Disconnected with error: \(err)")
        } else {
            print("Successfuly disconnected")
        }
        state = .disconnected
    }
}
