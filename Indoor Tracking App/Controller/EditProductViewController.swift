//
//  EditProductViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 6/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit

class EditProductViewController: UIViewController {
    
    var cellNumber: String?

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = cellNumber
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
