//
//  ResponseApod.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.

import Foundation

// MARK: - Apod
struct Apod: Codable {
    let date, explanation, mediaType, serviceVersion: String
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date, explanation
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}
