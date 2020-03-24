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


let regionConstraint = CLBeaconIdentityConstraint(uuid: proximityUUID!)
let proximityUUID = UUID(uuidString:"98374d0a-fa8f-43ab-968b-88eaf83c6e4c")
let beaconID = "My region"
var beacon: CLBeacon = CLBeacon()
var beaconList: [CLBeacon] = []

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        locationManager.startRangingBeacons(satisfying: regionConstraint)
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        let knownBeacons = beacons.filter({$0.proximity != CLProximity.unknown})
        if knownBeacons.count > 0 {
            // updateDistance(beacons[0].proximity, beacons[0].rssi)
            let closestBeacon = knownBeacons[0]
            if closestBeacon.accuracy != -1.0 && closestBeacon.accuracy <= 1.0 {
                updateColor(forBeacon: closestBeacon)
            }
            print(knownBeacons)
        } else {
            // updateDistance(.unknown, 0)
        }
    }
    
    func updateColor(forBeacon beacon: CLBeacon) {
        switch beacon.major {
        case 0:
            imageView.image = UIImage(named: "coca-zero")
        case 1:
            imageView.image = UIImage(named: "chips")
        case 2:
            imageView.image = UIImage(named: "tissue-box")
        default:
            fatalError()
        }
    }
    
    func updateDistance(_ distance: CLProximity, _ rssi: Int) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
            case .far:
                self.view.backgroundColor = UIColor.blue
            case .near:
                self.view.backgroundColor = UIColor.orange
            case .immediate:
                self.view.backgroundColor = UIColor.red
            @unknown default:
                fatalError()
            }
        }
    }
    
    func updateDistanceRSSI(_ distance: Int) {
        UIView.animate(withDuration: 0.8) {
            // TODO
        }
    }

}
