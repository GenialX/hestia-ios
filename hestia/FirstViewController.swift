//
//  FirstViewController.swift
//  smart home
//
//  Created by GenialX on 05/10/2017.
//  Copyright © 2017 ihuxu.com. All rights reserved.
//

import UIKit

import CoreLocation

class FirstViewController: UIViewController, AMapLocationManagerDelegate {
    var locationManager:AMapLocationManager?
    //var currentLocation:CLLocation?
    
    var iStream: InputStream?
    var oStream: OutputStream?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Socket Client
        let _ = Stream.getStreamsToHost(withName: "s.ihuxu.com", port: 1724, inputStream: &iStream, outputStream: &oStream)
        iStream?.open()
        oStream?.open()
        
        // Location
        /**
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
        **/
        AMapServices.shared().apiKey = "4597c0ec9b703297f7cfb62c28ccde7b"
        locationManager = AMapLocationManager()
        
        locationManager?.delegate = self
        locationManager?.distanceFilter = 20
        
        //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
        if UIDevice.current.systemVersion._bridgeToObjectiveC().doubleValue >= 9.0 {
            locationManager?.pausesLocationUpdatesAutomatically = true
        }
        
        locationManager?.locatingWithReGeocode = true
        
        //开始持续定位
        locationManager?.startUpdatingLocation()
        
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy);};");
        
        if let reGeocode = reGeocode {
            NSLog("reGeocode:%@", reGeocode)
        }
        
        let nsdic: NSDictionary = [
            "errno" : 0,
            "errmsg" : "successfully",
            "data" : [
                "message_type" : 1000,
                "lat" : location.coordinate.latitude,
                "lnt" : location.coordinate.longitude,
                "token" : "aaabbbccc"
            ]
        ]
        let jsonUtil = JsonUtil();
        let jsonString = jsonUtil.nsdictionary2JsonString(nsdic)
        sendLine(jsonString as String)
        NSLog("json sent:%@", jsonString)
    }
 
    func send(_ string: String) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        let data = string.data(using: .utf8)!
        data.copyBytes(to: &buf, count: data.count)
        oStream?.write(&buf, maxLength: data.count)
    }
    
    func sendLine(_ string: String) {
        send(string + "\n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
