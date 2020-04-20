//
//  Constants.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 25/3/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import Foundation

struct K {
    struct segues {
        static let logOnSegue = "logOn"
        static let showDetails = "showDetails"
        static let editProduct = "editProduct"
        static let addMenu = "addMenu"
        static let addProduct = "addProduct"
        static let addShelf = "addShelf"
    }
    
    struct cells {
        static let productCellID = "ReusableProductCell"
        static let productCell = "ProductCell"
    }
    
    struct FStore {
        struct Regions {
            static let regions = "regions"
            static let minor = "minor"
            static let major = "major"
            static let shelves = "shelves"
        }
        
        struct Shelves {
            static let shelves = "shelves"
            static let products = "products"
        }
        
        struct Products {
            static let products = "products"
            static let description = "description"
            static let retailPrice = "retailPrice"
            static let wholeSalePrice = "wholesalePrice"
        }
    }
}
