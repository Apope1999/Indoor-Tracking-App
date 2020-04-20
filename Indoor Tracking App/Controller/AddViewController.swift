//
//  AddViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 20/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    @IBAction func addNewShelfPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.segues.addShelf, sender: self)
    }
    
    @IBAction func addNewProductPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.segues.addProduct, sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
