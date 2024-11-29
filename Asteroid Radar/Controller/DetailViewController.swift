//
//  DetailViewController.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var asteroidNumber: Int = 0
    var asteroid = Asteroid()
    
    //var dataController : DataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    //var asteroid = Asteroid(context:context)
    
    var asteroidDetails = [String]()
    var asteroidContents = ["Name", "Close approach date", "Absolute magnitude", "Diameter", "Relative velocity", "Distance from earth", "More approach dates"]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTable()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // Fill array with asteroid details
    func detailTable () {
        if ((asteroid.isHazardous) == true) {
            self.imageView.image = UIImage(named: "asteroid_hazardous.png")
        } else {
            self.imageView.image = UIImage(named: "asteroid_safe.png")
        }
        
        asteroidDetails.append(asteroid.name!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let approachDate = dateFormatter.date(from: asteroid.closeApproachDate ?? "")
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_EN")
        
        asteroidDetails.append(dateFormatter.string(from: approachDate!))
        asteroidDetails.append(String(asteroid.absoluteMagnitudeH))
        asteroidDetails.append((NSString(format: "%.1f", asteroid.estimatedDiameter) as String) + " m")
        asteroidDetails.append((NSString(format: "%.1f", asteroid.relativeVelocity) as String) + " km/h" )
        asteroidDetails.append((NSString(format: "%.1f", asteroid.missDistance) as String) + " lunar distance")
        asteroidDetails.append("CLICK")
        self.tableView.reloadData()
    }
    
    
    // Number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asteroidDetails.count
    }
    
    // Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell", for: indexPath) as! DetailViewCell
        
        cell.detailContentLabel.text = asteroidContents[indexPath.row]
        cell.detailValueLabel.text = asteroidDetails[indexPath.row]
        
        return cell
    }
    
    
    // Show asteroid approach data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 6 {
            let approachController = self.storyboard!.instantiateViewController(withIdentifier: "ApproachViewController") as! ApproachViewController
            approachController.asteroid = self.asteroid
            self.navigationController!.pushViewController(approachController, animated: true)
        }
    }
    
}
