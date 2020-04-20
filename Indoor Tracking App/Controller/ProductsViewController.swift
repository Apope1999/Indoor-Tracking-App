//
//  ProductsViewController.swift
//  Indoor Tracking App
//
//  Created by Apostolos Pezodromou on 6/4/20.
//  Copyright © 2020 Apostolos Pezodromou. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class ProductsViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    var selectedProduct: String?
    var selectedProductSection: String?
    let locationManager = CLLocationManager()
    var beaconManager = BeaconManager()
    var regionListener: ListenerRegistration?
    var shelvesListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productTableView.dataSource = self
        productTableView.register(UINib(nibName: K.cells.productCell, bundle: nil), forCellReuseIdentifier: K.cells.productCellID)
        productTableView.delegate = self
        
        navigationItem.title = "Products"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        beaconManager.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        regionListener = beaconManager.loadRegionsFromFirebaseListener()
        shelvesListener = beaconManager.loadShelvesFromFirebaseListener()
        
        if let safeRegionConstraints = beaconManager.regionConstraint {
            locationManager.startRangingBeacons(satisfying: safeRegionConstraints)
        }
        
        productTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //regionListener?.remove()
        //shelvesListener?.remove()
        
        if let safeRegionConstraints = beaconManager.regionConstraint {
            locationManager.stopRangingBeacons(satisfying: safeRegionConstraints)
        }
    }
    
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                beaconManager.requestRegionsWithNoPermission()
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
            break
        }
        
        productTableView.reloadData()
        print(beaconManager.closestShelves)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.segues.addMenu, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.showDetails {
            let productVC = segue.destination as! ProductDetailsViewController
            productVC.productString = selectedProduct
            productVC.productSection = selectedProductSection
        }
    }
}

//MARK: - Table View Data Source
extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let shelfName = beaconManager.closestShelves[section]
        let shelf = beaconManager.shelves.first(where: {$0.id == shelfName})
        return shelf?.products.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return beaconManager.closestShelves.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.textLabel?.text = "\(beaconManager.closestShelves[section])"
        view.textLabel?.backgroundColor = UIColor.systemGray
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.productCellID, for: indexPath) as! ProductCell
        
        let shelfName = beaconManager.closestShelves[indexPath.section]
        let shelf = beaconManager.shelves.first(where: {$0.id == shelfName})
        
        cell.productLabel.text = "\(shelf!.products[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

//MARK: - Table View Delegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? ProductCell
        
        //
        let sectionHeaderView = productTableView.headerView(forSection: indexPath.section)
        selectedProductSection = sectionHeaderView?.textLabel?.text
        //
        
        selectedProduct = cell?.productLabel.text
        performSegue(withIdentifier: K.segues.showDetails, sender: self)
        cell?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as? ProductCell
            let sectionHeaderView = productTableView.headerView(forSection: indexPath.section)
            
            selectedProductSection = sectionHeaderView?.textLabel?.text
            selectedProduct = cell?.productLabel.text
            
            beaconManager.deleteProductFromFirebase(withName: selectedProduct!, from: selectedProductSection!)
        }
    }
}

//MARK: - Location & Beacon Manager Delegate
extension ProductsViewController: CLLocationManagerDelegate, BeaconManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        let knownBeacons = beacons.filter({$0.proximity != CLProximity.unknown})
        if knownBeacons.count > 0 {
            beaconManager.updateRegionOrder(regions: beacons)
        }
    }
    
    func didUpdateRegions(_ beaconManager: BeaconManager, regions: [String]) {
        productTableView.reloadData()
    }
    
    func startRanging(_ beaconManager: BeaconManager) {
        if let safeRegionConstraints = beaconManager.regionConstraint {
            locationManager.startRangingBeacons(satisfying: safeRegionConstraints)
        }
    }
    
    func stopRanging(_ beaconManager: BeaconManager) {
        if let safeRegionConstraints = beaconManager.regionConstraint {
            locationManager.stopRangingBeacons(satisfying: safeRegionConstraints)
        }
    }
    
    func didDeleteProduct(_ beaconManager: BeaconManager) {
        productTableView.reloadData()
    }
    
    func didFail() {
        print("I failed")
    }
}
