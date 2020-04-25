//
//  ViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 16/1/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var beaconManager = BeaconManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButoonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: K.segues.logOnSegue, sender: self)
                }
            }
        }
    }
    
    @IBAction func loggedOnPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: K.segues.logOnSegue, sender: self)
                }
            }
        }
    }
    
}


