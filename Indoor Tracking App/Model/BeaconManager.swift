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
    func didUpdateRegions(_ beaconManager: BeaconManager, regions: [String])
    func startRanging(_ beaconManager: BeaconManager)
    func stopRanging(_ beaconManager: BeaconManager)
    func didFail()
}

class BeaconManager {
    
    let regionConstraint: CLBeaconIdentityConstraint?
    var regions: [Region] = []
    var shelves: [Shelf] = []
    var products: [Product] = []
    var closestShelves: [String] = []
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
    
    
    
    func getRegion(minor: CLBeaconMinorValue, major: CLBeaconMajorValue) -> Region? {
        for region in regions {
            if region.minor == minor && region.major == major {
                return region
            }
        }
        return nil
    }
    
    func getShelf(id: String) -> Shelf? {
        return nil
    }
    
    func updateRegionOrder(regions: [CLBeacon]) {
        closestShelves.removeAll(keepingCapacity: false)
        for beacon in regions {
            if let minor = CLBeaconMinorValue(exactly: beacon.minor), let major = CLBeaconMajorValue(exactly: beacon.major) {
                print(self.regions)
                if let existingRegion = getRegion(minor: minor, major: major) {
                    print("Existing region \(existingRegion)")
                    for shelf in existingRegion.shelves {
                        closestShelves.append(shelf)
                        print("I registered a region")
                    }
                }
            } else {
                delegate?.didFail()
                return
            }
        }
        
        delegate?.didUpdateRegions(self, regions: closestShelves)
    }
    
    func requestRegionsWithNoPermission() {
        closestShelves.removeAll(keepingCapacity: false)
        for region in regions {
            closestShelves.append(contentsOf: region.shelves)
        }
        
        delegate?.didUpdateRegions(self, regions: closestShelves)
    }
}

//MARK: - Update Local Model
extension BeaconManager {
    func addNewRegion(regionId: String, minor: CLBeaconMinorValue, major: CLBeaconMajorValue, shelves: [String]) {
        let tempRegion = Region(id: regionId, minor: minor, major: major, shelves: shelves)
        regions.append(tempRegion)
    }
    
    func addNewShelf(shelfId: String, products: [String]) {
        let tempShelf = Shelf(id: shelfId, products: products)
        shelves.append(tempShelf)
    }
    
//    func addNewProduct(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
}

//MARK: - Firebase Functions
extension BeaconManager {
    func loadRegionsFromFirebaseListener() -> ListenerRegistration {
        delegate?.stopRanging(self)
        return db.collection(K.FStore.Regions.regions).addSnapshotListener { (documentSnapshot, err) in
            if let error = err {
                print(error)
            } else {
                self.regions = []
                for document in documentSnapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    
                    self.addNewRegion(regionId: id, minor: data[K.FStore.Regions.minor] as! CLBeaconMinorValue, major: data[K.FStore.Regions.major] as! CLBeaconMajorValue, shelves: data[K.FStore.Regions.shelves] as! [String])
                    print(self.regions)
                }
                self.delegate?.startRanging(self)
            }
        }
        
    }
    
    func loadShelvesFromFirebaseListener() -> ListenerRegistration {
        delegate?.stopRanging(self)
        return db.collection(K.FStore.Shelves.shelves).addSnapshotListener { (documentSnapshot, err) in
            if let error = err {
                print(error)
            } else {
                self.regions = []
                for document in documentSnapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    
                    self.addNewShelf(shelfId: id, products: data[K.FStore.Shelves.products] as! [String])
                }
                self.delegate?.startRanging(self)
            }
        }
    }
}

//MARK: - Deprecated Methods
extension BeaconManager {
    func loadRegionsFromFirebase() {
        db.collection(K.FStore.Regions.regions).getDocuments { (querySnapshot, err) in
            if let error = err {
                print(error)
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    
                    self.addNewRegion(regionId: id, minor: data[K.FStore.Regions.minor] as! CLBeaconMinorValue, major: data[K.FStore.Regions.major] as! CLBeaconMajorValue, shelves: data[K.FStore.Regions.shelves] as! [String])
                }
            }
        }
    }
    
    func loadShelvesFromFirebase() {
        db.collection(K.FStore.Shelves.shelves).getDocuments { (querySnapshot, err) in
            if let error = err {
                print(error)
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    
                    self.addNewShelf(shelfId: id, products: data[K.FStore.Shelves.products] as! [String])
                }
            }
        }
    }
}

