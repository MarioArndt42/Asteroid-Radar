//
//  MainViewController.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//  Change 29.05.2024

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UIButton!
    @IBAction func newsButton(_ sender: Any) {
        showNews()
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var dictNeo = [String: [NearEarthObject]]()
    var arrayNeo = [NearEarthObject]()
    var asteroidList: [Asteroid] = []
    var dataController : DataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    var startDate: String = ""
    var endDate: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
       
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDate = dateFormatter.string(from: date)
        let date2 = Calendar.current.date(byAdding: .day, value: 5, to: date)!
        endDate = dateFormatter.string(from: date2)
        
        loadPhoto()
        getListofAsteroids()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
     
    // Download list of asteroids
    func getListofAsteroids() {
        self.fetchAsteroids()
        self.tableView.reloadData()
        ClientNASA.getNeoList(startDate: startDate, endDate: endDate, completion: { result in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            switch result {
            case .success(let neo):
                self.dictNeo = neo.nearEarthObjects
                
                for value in self.dictNeo.values {
                    for asteroid in value {
                        self.saveNeo(neoAsteroid: asteroid, completion: { success in
                            if success {
                                self.fetchAsteroids()
                                self.tableView.reloadData()
                            }
                        })
                    }
                }
                
            case .failure(_):
                self.showAlert(message: "You're offline. Check your connection.", title: "No internet connection")
            }
        })
        
    }
    
    
    // Save asteroids in Core Data
    func saveNeo(neoAsteroid: NearEarthObject?, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let asteroid = Asteroid(context: self.dataController.viewContext)
            asteroid.id = neoAsteroid?.id
            asteroid.name = neoAsteroid?.name
            asteroid.isHazardous = ((neoAsteroid!.isPotentiallyHazardousAsteroid))
            asteroid.closeApproachDate = neoAsteroid?.closeApproachData[0].closeApproachDate
            asteroid.absoluteMagnitudeH = Float(neoAsteroid?.absoluteMagnitudeH ?? 0)
            asteroid.estimatedDiameter = Float(neoAsteroid?.estimatedDiameter.meters.estimatedDiameterMin ?? 0)
            asteroid.relativeVelocity = Float(neoAsteroid?.closeApproachData[0].relativeVelocity.kilometersPerHour ?? "0")!
            asteroid.missDistance = Float(neoAsteroid?.closeApproachData[0].missDistance.lunar ?? "0")!
            
            do {
                try self.dataController.viewContext.save()
            } catch {
                self.showAlert(message: "Try again.", title: "Error saving asteroids")
            }
            completion(true)
        }
    }
    
    
    // Load asteroids from Core Data
    func fetchAsteroids() -> Int {
        let fetchRequest: NSFetchRequest<Asteroid> = Asteroid.fetchRequest()
        
        // Sort and select from startDate
        let predicate = NSPredicate(format: "%K >= %@", "closeApproachDate", startDate)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "closeApproachDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try dataController.viewContext.fetch(fetchRequest)
            asteroidList = result
            /*
             for managedObject in result {
             if let closeApproachDate = managedObject.value(forKey: "closeApproachDate") {
             print("Result: \(closeApproachDate)")
             }
             }
             */
        }
        catch {
            self.showAlert(message: "Try again.", title: "Error loading asteroids")
        }
        return asteroidList.count
    }
    
    
    // Load saved APOD photo
    func loadPhoto(){
        if let image = UserDefaults.standard.data(forKey: "Image") {
            self.imageView.image = UIImage(data: image)
        }
        if let title = UserDefaults.standard.string(forKey: "Title") {
            self.labelTitle.setTitle(title, for: .normal)
            self.labelTitle.tintColor = UIColor.white
        }
        loadPhotoURL()
    }
    
    
    // Download APOD JSON
    func loadPhotoURL() {
        ClientNASA.getApodJSON(completion: { result in
            switch result {
            case .success(let apod):
                if apod.mediaType != "video" {
                    let apodURL = apod.url
                    self.loadPhotoImage(apodURL: apodURL)
                    self.labelTitle.setTitle(apod.title, for: .normal)
                    self.labelTitle.tintColor = UIColor.white
                    UserDefaults.standard.set(apod.title, forKey: "Title")
                }
                
            case .failure(_):
                self.showAlert(message: "You're offline. Check your connection.", title: "No internet connection")
            }
        })
    }
    
    
    // Download APOD
    func loadPhotoImage(apodURL: String) {
        ClientNASA.getApodImage(request: URL(string: apodURL)!, completion: { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: image)
                    UserDefaults.standard.set(image, forKey: "Image")
                }
                
            case .failure(_):
                self.showAlert(message: "You're offline. Check your connection.", title: "No internet connection")
            }
        })
    }
    
    
    // Number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asteroidList.count
    }
    
    // Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Asteroid Cell", for: indexPath)
        let asteroid = asteroidList[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let approachDate = dateFormatter.date(from: asteroid.closeApproachDate ?? "")
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_EN")
        
        cell.detailTextLabel?.text = dateFormatter.string(from: approachDate!)
        cell.textLabel?.text = asteroid.name
        
        if asteroid.isHazardous {
            cell.imageView?.image = UIImage(named: "asteroid_hazardous.png")
        } else {
            cell.imageView?.image = UIImage(named: "asteroid_safe.png")
        }
        return cell
    }
    
    // Show asteroid details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.asteroid = asteroidList[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    // Show CNEOS news
    func showNews() {
        let newsController = self.storyboard!.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        self.navigationController!.pushViewController(newsController, animated: true)
    }
    
}

