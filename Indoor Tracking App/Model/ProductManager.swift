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
    func didUpdateProductPage(_ productManager: ProductManager, product: Product)
    func didDeleteProduct(_ productManager: ProductManager)
    func didAddProduct(_ productManager: ProductManager)
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
    
    func deleteProductFromFirebase(withName productName: String, from shelfName: String) {
        let shelvesCol = db.collection(K.FStore.Shelves.shelves).document(shelfName)
        
        shelvesCol.updateData([
            K.FStore.Shelves.products: FieldValue.arrayRemove([productName])
        ])
        
        db.collection(K.FStore.Products.products).document(productName).delete() { err in
            if let error = err {
                print(error)
                self.delegate?.didFail()
                return
            }
        }
        
        delegate?.didDeleteProduct(self)
    }
    
    func addProductToFirebase(withName productName: String, description: String, wholesalePrice: Double, retailPrice: Double, atShelf shelfName: String) {
        let batch = db.batch()
        
        let productRef = db.collection(K.FStore.Products.products).document(productName)
        batch.setData(
            [
                K.FStore.Products.description : description,
                K.FStore.Products.retailPrice : retailPrice,
                K.FStore.Products.wholeSalePrice : wholesalePrice
        ], forDocument: productRef, merge: true)
        
        let shelfRef = db.collection(K.FStore.Shelves.shelves).document(shelfName)
        
        batch.updateData(
            [
                K.FStore.Shelves.products : FieldValue.arrayUnion([productName])
        ], forDocument: shelfRef)
        
        batch.commit { (err) in
            if let error = err {
                print(error)
                self.delegate?.didFail()
            } else {
                self.delegate?.didAddProduct(self)
            }
        }
    }
}
