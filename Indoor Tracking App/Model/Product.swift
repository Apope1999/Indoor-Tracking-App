//
//  Product.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 24/3/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import Foundation
import UIKit

struct Product {
    var name: String
    var image: UIImage?
    var description: String
    var retailPrice: Double
    var wholesalePrice: Double
    
    init(name: String, description: String, retailPrice: Double, wholesalePrice: Double) {
        self.name = name
        self.description = description
        self.retailPrice = retailPrice
        self.wholesalePrice = wholesalePrice
    }
}
