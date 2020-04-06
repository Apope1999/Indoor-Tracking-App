//
//  ProductDetailsViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 6/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    var cellNumber: String?
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionLabel.text = cellNumber
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.editProduct {
            let editProductVC = segue.destination as! EditProductViewController
            editProductVC.cellNumber = cellNumber
        }
    }
}
