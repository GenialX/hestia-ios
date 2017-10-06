//
//  FirstViewController.swift
//  smart home
//
//  Created by GenialX on 05/10/2017.
//  Copyright © 2017 ihuxu.com. All rights reserved.
//

import UIKit

import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    
    var iStream: InputStream?
    var oStream: OutputStream?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Socket Client
        let _ = Stream.getStreamsToHost(withName: "s.ihuxu.com", port: 1722, inputStream: &iStream, outputStream: &oStream)
        iStream?.open()
        oStream?.open()
        
        // Location
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        send("lon:\n\r和")
        print(currentLocation?.coordinate.longitude)
        print(currentLocation?.coordinate.latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
 
    func send(_ string: String) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        let data = string.data(using: .utf8)!
        data.copyBytes(to: &buf, count: data.count)
        oStream?.write(&buf, maxLength: data.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
