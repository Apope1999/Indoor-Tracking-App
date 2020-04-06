//
//  BeaconManager.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 24/3/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

protocol BeaconManagerDelegate {
    func didUpdateRegions(_ beaconManager: BeaconManager, regions: [Region])
    func didFail()
}

struct BeaconManager {
    
    let regionConstraint: CLBeaconIdentityConstraint?
    var regions: [Region] = []
    var closestRegions: [Region] = []
    var db = Firestore.firestore()
    var delegate: BeaconManagerDelegate?
    
    init() {
        let proximityUUID = UUID(uuidString:"98374d0a-fa8f-43ab-968b-88eaf83c6e4c")
        
        if let uuid = proximityUUID {
            regionConstraint = CLBeaconIdentityConstraint(uuid: uuid)
        } else {
            regionConstraint = nil
        }
    }
    
    mutating func addNewRegion(minor: CLBeaconMinorValue, major: CLBeaconMajorValue) {
        let tempRegion = Region(minor: minor, major: major, shelves: [])
        
        for region in regions {
            if region.minor == tempRegion.minor && region.major == tempRegion.major {
                return
            } else {
                regions.append(tempRegion)
            }
        }
    }
    
    func getRegion(minor: CLBeaconMinorValue, major: CLBeaconMajorValue) -> Region? {
        for region in regions {
            if region.minor == minor && region.major == major {
                return region
            }
        }
        return nil
    }
    
    func addShelf(toRegion region: Region) {
        
    }
    
    
    mutating func updateRegionOrder(regions: [CLBeacon]) {
        closestRegions.removeAll(keepingCapacity: false)
        for beacon in regions {
            if let minor = CLBeaconMinorValue(exactly: beacon.minor), let major = CLBeaconMinorValue(exactly: beacon.major) {
                
                if let existingRegion = getRegion(minor: minor, major: major) {
                    closestRegions.append(existingRegion)
                }
            } else {
                delegate?.didFail()
            }
        }
        
        delegate?.didUpdateRegions(self, regions: closestRegions)
    }
}

