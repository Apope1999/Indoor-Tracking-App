//
//  RegionManager.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 20/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import Foundation
import Firebase

protocol RegionManagerDelegate {
    func didAddRegion(_ regionmanager: RegionManager)
}

struct RegionManager {
    var db = Firestore.firestore()
    var delegate: RegionManagerDelegate?
    
    
    func addRegion(major: Int, minor: Int) {
        db.collection(K.FStore.Regions.regions).addDocument(data: [
            "major" : major,
            "minor" : minor,
            "shelves" : []
        ]) { err in
            if let error = err {
                print(error)
            } else {
                self.delegate?.didAddRegion(self)
            }
        }
    }
}
