//
//  NewsViewController.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//

import UIKit
import CoreData

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var arrayNews = [News]()
    var arrayNews: [News] = []
    var startDate: String = ""
    var endDate: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataController : DataController = (UIApplication.shared.delegate as! AppDelegate).dataController
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //deletePhotos()
        
        activityIndicator.startAnimating()
        getNews()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    // Delete all photos for a location in Core Data
    func deletePhotos() {
        for photo in arrayNews {
            dataController.viewContext.delete(photo)
            do {
                try self.dataController.viewContext.save()
            } catch {
                self.showAlert(message: error.localizedDescription, title: "Error deleting photos")
            }
        }
        arrayNews = []
        print("News deleted")
        //fetchNews()
        //numberPhotos = 0
    }
    
    
    
    
    
    
    // Download NASA news
    func getNews() {
        fetchNews()
        self.tableView.reloadData()
        ClientNASA.getNewsJpl(completion: { result in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            switch result {
            case .success(let newsList):
                for index in 0 ..< newsList.count {
                    self.saveNews(newsItem: newsList[index], completion: { success in
                        if success {
                            self.fetchNews()
                            self.tableView.reloadData()
                        }
                    })
                }
                
            case .failure(_):
                self.showAlert(message: "You're offline. Check your connection.", title: "No internet connection")
            }
        })
    }
    
    
    // Save news in Core Data
    func saveNews(newsItem: NewsItem, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let news = News(context: self.dataController.viewContext)
            news.title = newsItem.title
            news.pubDate = newsItem.pubDate
            news.link = newsItem.link
            
            do {
                try self.dataController.viewContext.save()
            } catch {
                self.showAlert(message: "Try again.", title: "Error saving news")
            }
            completion(true)
        }
    }
    
    
    // Load news from Core Data
    func fetchNews() -> Void {
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try dataController.viewContext.fetch(fetchRequest)
            arrayNews = result
        }
        catch {
            self.showAlert(message: "Try again.", title: "Error loading news")
        }
    }
    
    
    // Number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNews.count
    }
    
    // Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "News Cell") as! NewsViewCell
        
        let news = arrayNews[indexPath.row]
        cell.newsImageView.image = UIImage(named: "NASA_logo.svg")
        cell.newsTitleLabel.text = news.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let pubDate = dateFormatter.date(from: news.pubDate ?? "")
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_EN")
        
        cell.newsDateLabel.text = dateFormatter.string(from: pubDate ?? Date())
        return cell
    }
    
    
    // Show news in browser
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let urlString = arrayNews[indexPath.row].link
        guard let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url)
                
        else {
            self.showAlert(message: "Can't open link", title: "Invalid link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
}

