//
//  AddShelfViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 21/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit

class AddShelfViewController: UIViewController, ShelfManagerDelegate {
    var shelfManager = ShelfManager()
    
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let major = Int(majorTextField.text!) else { return }
        guard let minor = Int(minorTextField.text!) else { return }
        guard let shelfName = nameTextField.text else { return }
        
        shelfManager.addNewShelf(named: shelfName, major: major, minor: minor)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shelfManager.delegate = self
    }
    

    // MARK: - ShelfManagerDelegate
    func didAddShelf(_ shelfManager: ShelfManager) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didFail() {
        print("I failed ;(")
    }
}
