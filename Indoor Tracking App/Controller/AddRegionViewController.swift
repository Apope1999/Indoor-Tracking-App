//
//  AddRegionViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 20/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit

class AddRegionViewController: UIViewController, RegionManagerDelegate {

    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    var regionManager = RegionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        regionManager.delegate = self
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let major = Int(majorTextField.text!) else { return }
        guard let minor = Int(minorTextField.text!) else { return }
        
        regionManager.addRegion(major: major, minor: minor)
    }
    
    func didAddRegion(_ regionmanager: RegionManager) {
        dismiss(animated: true, completion: nil)
    }
}
