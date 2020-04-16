//
//  ProductDetailsViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 6/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    var productString: String?
    var product: Product?
    var productManager = ProductManager()
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retailPriceLabel: UILabel!
    @IBOutlet weak var wholesalePriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productManager.delegate = self
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false

        if let productSafeString = productString {
            navigationItem.title = productSafeString
            productManager.loadProductFromFirebase(withName: productSafeString)
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete \(productString!)", message: "This action cannot be undone. Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            print("poof")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.editProduct {
            let editProductVC = segue.destination as! EditProductViewController
            
        }
    }
}

extension ProductDetailsViewController: ProductManagerDelegate {
    func didUpdateProductPage(_ beaconManager: ProductManager, product: Product) {
        descriptionLabel.text = product.description
        retailPriceLabel.text = "\(product.retailPrice)€"
        wholesalePriceLabel.text = "\(product.wholesalePrice)€"
    }
    
    
    
    func didFail() {
        print("I failed")
    }
}
