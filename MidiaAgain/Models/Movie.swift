//
//  Movie.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

struct Movie {
    
    let movieId: String
    let name: String
    let director: String?
    let releaseDate: Date?
    let description: String?
    let coverURL: URL?
    let price: Float?
    let gender: String?
    
    init(movieId: String, name: String, director: String, releaseDate: Date, description: String, coverURL: URL, price: Float, gender: String) {
        self.movieId = movieId
        self.name = name
        self.director = director
        self.releaseDate = releaseDate
        self.description = description
        self.coverURL = coverURL
        self.price = price
        self.gender = gender
    }
}

extension Movie: Codable{
    
    enum CodingKeys: String, CodingKey {
        case movieId = "trackId"
        case name = "trackName"
        case director = "artistName"
        case releaseDate
        case description = "longDescription"
        case coverUrl =  "artworkUrl100"
        case price = "trackPrice"
        case gender = "primaryGenreName"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        movieId = String(try container.decode(Int.self, forKey: .movieId ))
        name = try container.decode(String.self, forKey: .name )
        director = try container.decodeIfPresent(String.self, forKey: .director )
        
        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            releaseDate = DateFormatter.moviesDateFormatter.date(from: releaseDateString)
        } else {
            releaseDate = nil
        }
        
        description = try container.decodeIfPresent(String.self, forKey: .description)
        coverURL = try container.decodeIfPresent(URL.self, forKey: .coverUrl)
        price = try container.decodeIfPresent(Float.self, forKey: .price)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(Int(movieId), forKey: .movieId)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(director, forKey: .director)
        let formattedReleaseDate = DateFormatter.moviesDateFormatter.string(from: releaseDate!)
        try container.encodeIfPresent(formattedReleaseDate, forKey: .releaseDate)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(coverURL, forKey: .coverUrl)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(gender, forKey: .gender)
    }
}

extension Movie: MediaItemProvidable {
    var imageURL: URL? {
        return coverURL
    }
    
    var mediaItemId: String {
        return movieId
    }
    
    var title: String {
        return name
    }
}

extension Movie: MediaItemDetailedProvidable {
    
    
    var creatorName: String? {
        return director
    }
    
    var rating: Float? {
        return nil
    }
    
    var numberOfReviews: Int? {
        return nil
    }
    
    var creationDate: Date? {
        return releaseDate
    }
    
}
