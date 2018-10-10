//
//  Server.swift
//  hestia
//
//  Created by GenialX on 2018/10/10.
//  Copyright © 2018 ihuxu.com. All rights reserved.
//

import Foundation

class Server {
    static let ServerInstance = Server()
    
    private var iStream: InputStream?
    private var oStream: OutputStream?
    
    var isAlive: Bool {
        get {
            return self.isAlive
        }
        set {
            self.isAlive = newValue
        }
    }
    
    private init() {
        Stream.getStreamsToHost(withName: "s.ihuxu.com", port: 1724, inputStream: &iStream, outputStream: &oStream)
        iStream?.open()
        oStream?.open()
    }
    
    func reconnect() -> Bool {
        return true
    }
    
    func send(_ string: String) -> Bool {
        var buf = Array(repeating: UInt8(0), count: 1024)
        let data = string.data(using: .utf8)!
        data.copyBytes(to: &buf, count: data.count)
        oStream?.write(&buf, maxLength: data.count)
        return true
    }
    
    func sendLine(_ string: String) -> Bool {
        return send(string + "\n")
    }
}
