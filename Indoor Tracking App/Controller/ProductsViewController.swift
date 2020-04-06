//
//  ProductsViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 6/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit
import CoreLocation

class ProductsViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    var selectedRow: Int?
    let locationManager = CLLocationManager()
    var beaconManager = BeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productTableView.dataSource = self
        productTableView.register(UINib(nibName: K.cells.productCell, bundle: nil), forCellReuseIdentifier: K.cells.productCellID)
        productTableView.delegate = self
        
        navigationItem.title = "Products"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        locationManager.delegate = self
        beaconManager.delegate = self
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.identifier == K.segues.showDetails {
            let productVC = segue.destination as! ProductDetailsViewController
            productVC.cellNumber = String(describing: selectedRow)
        }
    }
}

//MARK: - Table View Data Source
extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Section"
        label.backgroundColor = UIColor.systemGray
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.productCellID, for: indexPath) as! ProductCell
        cell.productLabel.text = "\(indexPath.row)"
        return cell
    }
}

//MARK: - Table View Delegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: K.segues.showDetails, sender: self)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}

//MARK: - Location & Beacon Manager Delegate
extension ProductsViewController: CLLocationManagerDelegate, BeaconManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if beacons.count > 0 {
            beaconManager.updateRegionOrder(regions: beacons)
        }
    }
    
    func didUpdateRegions(_ beaconManager: BeaconManager, regions: [Region]) {
        productTableView.reloadData()
    }
    
    func didFail() {
        
    }
}
