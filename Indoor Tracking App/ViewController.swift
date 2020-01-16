//
//  ViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 16/1/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit
import CoreLocation

let majorValue: CLBeaconMajorValue = 0
let minorValue: CLBeaconMinorValue = 0

let locationManager = CLLocationManager()

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestAlwaysAuthorization()
    }


}

