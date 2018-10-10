//
//  JsonUtil.swift
//  hestia
//
//  Created by GenialX on 06/10/2017.
//  Copyright © 2017 ihuxu.com. All rights reserved.
//

import Foundation

class JsonUtil {
    func nsdictionary2JsonString(_ nsdictionary: NSDictionary) -> NSString {
        if (!JSONSerialization.isValidJSONObject(nsdictionary)) {
            print("invalid json object")
            return ""
        }
        let data: NSData! = try? JSONSerialization.data(withJSONObject: nsdictionary, options: []) as NSData
        return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!
    }
}
