//
//  ClientNASANeo.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//

import Foundation
import UIKit

class ClientNASA {
    
    enum CustomError: Error {
        case decodingError
        case networkError
    }
    
    static let apiKey = "DEMO_KEY"
    static var startDate: String = ""
    static var endDate: String = ""
    static var neoId: String = ""
    
    enum Endpoint {
        static let base = "https://api.nasa.gov/"
    //    static let urlJpl = "https://www.jpl.nasa.gov/feeds/news/news.rss"
        static let urlJpl = "https://cneos.jpl.nasa.gov/feed/news.xml"
        
        case getNeoList
        case getAsteroid
        case getApodJSON
        case getNewsJpl
        
        private var stringValue: String {
            switch self {
            case .getNeoList: return Endpoint.base + "neo/rest/v1/feed?start_date=" + startDate + "&end_date=" + endDate + "&api_key=" + apiKey
            case .getAsteroid: return Endpoint.base + "neo/rest/v1/neo/" + neoId + "?api_key=" + apiKey
      //      case .getApodJSON: return Endpoint.base + "planetary/apod?api_key=" + apiKey
            case .getApodJSON: return Endpoint.base + "planetary/apod?api_key=" + apiKey
            case .getNewsJpl: return Endpoint.urlJpl
            }
        }
        
        var url: URL { return URL(string: stringValue)! }
    }
    
    
    // Get Neo List
    class func getNeoList(startDate: String, endDate: String, completion: @escaping (Result<Neo, CustomError>) -> Void) {
        let request = URLRequest(url: Endpoint.getNeoList.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion (.failure(.networkError))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(Neo.self, from: data)
                    completion(.success(response))
                } catch {
                    completion (.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    
    // Get Asteroid (for close approach dates)
    class func getAsteroid(neoId: String, completion: @escaping (Result<ApproachData, CustomError>) -> Void) {
        self.neoId = neoId
        let request = URLRequest(url: Endpoint.getAsteroid.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion (.failure(.networkError))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ApproachData.self, from: data)
                    completion(.success(response))
                } catch {
                    completion (.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    
    // Get APOD JSON
    class func getApodJSON(completion: @escaping (Result<Apod, CustomError>) -> Void) {
        let request = URLRequest(url: Endpoint.getApodJSON.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion (.failure(.networkError))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(Apod.self, from: data) 
                    completion(.success(response))
                } catch {
                    completion (.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    
    // Download APOD single photo
    class func getApodImage(request: URL, completion: @escaping (Result<Data, CustomError>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion (.failure(.networkError))
                    return
                }
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    
    // Download JPL News
    class func getNewsJpl(completion: @escaping (Result<[NewsItem], CustomError>) -> Void) {
        let request = URLRequest(url: Endpoint.getNewsJpl.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion (.failure(.networkError))
                    return
                }
                
                let parser = NewsParser()
                let xmlParser = XMLParser(data: data)
                xmlParser.delegate = parser
                xmlParser.parse()
                completion(.success(parser.items))
            }
        }
        task.resume()
    }
    
}
