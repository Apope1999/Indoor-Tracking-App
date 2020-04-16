//
//  ProductManager.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 16/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import Foundation
import Firebase

protocol ProductManagerDelegate {
    func didUpdateProductPage(_ beaconManager: ProductManager, product: Product)
    //func didDeleteProduct(_ beaconManager: ProductManager)
    func didFail()
}

struct ProductManager {
    var db = Firestore.firestore()
    var delegate: ProductManagerDelegate?
    
    func loadProductFromFirebase(withName productName: String) {
        let productDoc = db.collection(K.FStore.Products.products).document(productName)
        
        productDoc.getDocument { (documentSnapshot, err) in
            if let error = err {
                print(error)
                self.delegate?.didFail()
            } else {
                let name = documentSnapshot!.documentID
                let data = documentSnapshot!.data()
                
                let desc = data![K.FStore.Products.description] as! String
                let retailPrice = data![K.FStore.Products.retailPrice] as! Double
                let wholesalePrice = data![K.FStore.Products.wholeSalePrice] as! Double
                
                let product = Product(name: name, description: desc, retailPrice: retailPrice, wholesalePrice: wholesalePrice)
                
                self.delegate?.didUpdateProductPage(self, product: product)
            }
        }
    }
}
