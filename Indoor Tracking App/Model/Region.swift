//
//  Region.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 24/3/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import Foundation
import CoreLocation

struct Region {
    let minor: CLBeaconMinorValue
    let major: CLBeaconMajorValue
    
    var shelves: [Shelf]
}
