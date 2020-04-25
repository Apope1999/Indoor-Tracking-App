//
//  AddProductViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 21/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, ProductManagerDelegate {
    
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var retailPriceTextField: UITextField!
    @IBOutlet weak var wholesalePriceTextField: UITextField!
    @IBOutlet weak var shelfTextField: UITextField!
    
    var productManager = ProductManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productManager.delegate = self
    }
    
    
    @IBAction func addButonPressed(_ sender: UIButton) {
        guard let retailPrice = Double(retailPriceTextField.text!) else { return }
        guard let wholesalePrice = Double(wholesalePriceTextField.text!) else { return }
        let productName = productNameTextField.text!
        let description = descriptionTextField.text!
        let shelfName = shelfTextField.text!
        
        productManager.addProductToFirebase(withName: productName, description: description, wholesalePrice: wholesalePrice, retailPrice: retailPrice, atShelf: shelfName)
    }
    
    //MARK: - ProductManagerDelegate
    func didUpdateProductPage(_ productManager: ProductManager, product: Product) {
        return
    }
    
    func didDeleteProduct(_ productManager: ProductManager) {
        return
    }
    
    func didAddProduct(_ productManager: ProductManager) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didFail() {
        print("I failed")
    }
}
