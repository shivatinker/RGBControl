//
//  SubnetScanner.swift
//  RGBDriver
//
//  Created by Andrew Zinoviev on 3/21/20.
//  Copyright © 2020 Andrew Zinoviev. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public protocol SubnetScannerDelegate{
    func hostFound(host: String)
    func scanDidFinished()
}

public class SubnetScanner:NSObject, GCDAsyncSocketDelegate{
    
    let g = DispatchGroup()
    let semaphore = DispatchSemaphore(value: 50)
    var res = [String]()
    let WIFI_IFACE_NAME = "en0"
    
    var delegate: SubnetScannerDelegate
    
    public init(delegate: SubnetScannerDelegate) {
        self.delegate = delegate
    }
    
    public func scanForTCPPortOpened(port: UInt16 = 56441){
        let allInterfaces = Interface.allInterfaces()
        guard let wifi = allInterfaces.filter({$0.family == .ipv4 && $0.name == WIFI_IFACE_NAME}).first,
            let netmask = wifi.netmask,
            let address = wifi.address else {
                self.g.notify(queue: DispatchQueue.global(qos: .userInteractive)){
                    self.delegate.scanDidFinished()
                }
                return
        }
        
        let subnet = SubnetScanner.addressToInt(addr: netmask)
        let ip = SubnetScanner.addressToInt(addr: address)
        
        let begin = (ip & subnet) + 1
        let end = ((ip & subnet) | ~subnet) - 1
        DispatchQueue.global(qos: .userInitiated).async{
            for cur in begin...end{
                let addr = SubnetScanner.IntToAddr(int: cur)
                self.semaphore.wait()
                DispatchQueue.global(qos: .userInitiated).async{
                    self.g.enter()
                    //print("Pinging \(addr)...")
                    let mSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global(qos: .userInitiated))
                    do{
                        try mSocket.connect(toHost: addr, onPort: port, withTimeout: 0.3)
                    } catch let err{
                        print(err)
                        self.g.leave()
                        self.semaphore.signal()
                    }
                }
            }
            self.g.notify(queue: DispatchQueue.global(qos: .userInteractive)){
                self.delegate.scanDidFinished()
            }
        }
    }
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.delegate.hostFound(host: host)
        }
        
        sock.disconnect()
    }
    
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        //print("() -- Disconnected, \(err)")
        
        g.leave()
        semaphore.signal()
    }
    
    private static func addressToInt(addr: String) -> UInt32{
        let b = addr.split(separator: ".").map{UInt8($0)}
        var v: UInt32 = 0
        for i in 0...3{
            v += (UInt32(b[3 - i]!)) << (UInt32(i * 8))
        }
        return v
    }
    
    private static func IntToAddr(int: UInt32) -> String{
        return "\((int >> 24) & 0xFF).\((int >> 16) & 0xFF).\((int >> 8) & 0xFF).\((int >> 0) & 0xFF)"
    }
}
