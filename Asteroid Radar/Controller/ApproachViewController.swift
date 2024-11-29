//
//  ApproachViewController.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//

import Foundation

import UIKit

class ApproachViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var asteroidNumber: Int = 0
    var asteroid = Asteroid()
    var approachList: [CloseApproachDatum] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        getAsteroid()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // Download list of asteroids
    func getAsteroid() {
        ClientNASA.getAsteroid(neoId: asteroid.id!, completion: { result in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            switch result {
            case .success(let approachData):
                self.approachList = approachData.closeApproachData
                self.tableView.reloadData()
                
            case .failure(_):
                self.showAlert(message: "You're offline. Check your connection.", title: "No internet connection")
            }
        })
    }
    
    
    // Number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approachList.count
    }
    
    
    // Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Approach Cell", for: indexPath) as! ApproachViewCell
        let approach = approachList[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let approachDate = dateFormatter.date(from: approach.closeApproachDate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_EN")
        
        cell.approachDateContentLabel?.text = "Approach Date"
        cell.distanceContentLabel?.text = "Distance"
        cell.velocityContentLabel?.text = "Velocity"
        cell.approachDateValueLabel?.text = dateFormatter.string(from: approachDate!)
        cell.distanceValueLabel?.text = (NSString(format: "%.1f", Float(approach.missDistance.lunar)!) as String) + " lunar distance"
        cell.velocityValueLabel?.text = (NSString(format: "%.1f", Float(approach.relativeVelocity.kilometersPerHour)!) as String) + " km/h"
        
        return cell
    }
    
}
