//
//  NewsParser.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//

import Foundation
import UIKit
import CoreData

class NewsParser : NSObject, XMLParserDelegate {
    
    var itemNr = 0
    
    var items: [NewsItem] = []
    
    var currentElement: String = ""
    var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var currentLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]) {
            
            currentElement = elementName
            if currentElement == "item" {
                currentTitle = ""
                currentLink = ""
                currentPubDate = ""
            }
        }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "title": currentTitle += string
        case "link" : currentLink += string
        case "pubDate": currentPubDate += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "item" {
            let start = currentPubDate.index(currentPubDate.startIndex, offsetBy: 5)
            let end = currentPubDate.index(currentPubDate.endIndex, offsetBy: -15)
            let currentPubDateShort = String(currentPubDate[start..<end])
            
            //Convert pubDate in sortable date format (for fetching in Core Data)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            let date = dateFormatter.date(from: currentPubDateShort)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let pubDateSortable = dateFormatter.string(from: date!)
            
            // First item is .js
            if currentTitle != "News" {
            let item = NewsItem(title: currentTitle, pubDate: pubDateSortable, link: currentLink)
            items += [item]
            }
        }
    }
    
}

