//
//  ShelfManager.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 21/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import Foundation
import Firebase

protocol ShelfManagerDelegate {
    func didAddShelf(_ shelfManager: ShelfManager)
    func didFail()
}

struct ShelfManager {
    var db = Firestore.firestore()
    var delegate: ShelfManagerDelegate?
    
    func addNewShelf(named regionName: String, major: Int, minor: Int) {
        let batch = db.batch()
        
        let shelfRef = db.collection(K.FStore.Shelves.shelves).document(regionName)
        batch.setData([K.FStore.Shelves.products : []], forDocument: shelfRef, merge: true)
        
        let regionQuery = db.collection(K.FStore.Regions.regions)
            .whereField(K.FStore.Regions.major, isEqualTo: major)
            .whereField(K.FStore.Regions.minor, isEqualTo: minor)
        
        regionQuery.getDocuments { (snapshot, err) in
            if let error = err {
                print(error)
                self.delegate?.didFail()
            } else {
                for document in snapshot!.documents {
                    let docRef = self.db.collection(K.FStore.Regions.regions).document(document.documentID)
                    batch.updateData([K.FStore.Regions.shelves: FieldValue.arrayUnion([regionName])], forDocument: docRef)
                }
                
                batch.commit { (err) in
                    if let error = err {
                        print(error)
                        self.delegate?.didFail()
                    } else {
                        self.delegate?.didAddShelf(self)
                    }
                }
            }
        }
    }
}
