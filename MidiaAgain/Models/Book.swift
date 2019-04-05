//
//  Book.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

struct Book {
    
    let bookId: String
    let title: String
    let authors: [String]?
    let publishedDate: Date?
    let description: String?
    let coverURL: URL?
    let rating: Float?
    let numberOfReviews: Int?
    let price: Float?
    
    init(bookId: String, title: String, authors: [String]? = nil, publishedDate: Date? = nil, description: String? = nil, coverUrl: URL? = nil, rating: Float? = nil, numberOfReviews: Int? = nil, price: Float? = nil) {
        self.bookId = bookId
        self.title = title
        self.authors = authors
        self.publishedDate = publishedDate
        self.description = description
        self.coverURL = coverUrl
        self.rating = rating
        self.numberOfReviews = numberOfReviews
        self.price = price
    }
    
}

extension Book: Codable {
    
    enum CodingKeys: String, CodingKey {
        case bookId = "id"
        case volumeInfo
        case title
        case authors
        case publishedDate
        case description
        case imageLinks
        case coverURL = "thumbnail"
        case rating = "averageRating"
        case numberOfReviews = "ratingsCount"
        case saleInfo
        case listPrice
        case price = "amount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        bookId = try container.decode(String.self, forKey: .bookId)
        
        let volumeInfoContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        title = try volumeInfoContainer.decode(String.self, forKey: .title)
        authors = try volumeInfoContainer.decodeIfPresent([String].self, forKey: .authors)
        if let publishedDateString = try volumeInfoContainer.decodeIfPresent(String.self, forKey: .publishedDate) {
            publishedDate = DateFormatter.booksDateFormatter.date(from: publishedDateString)
        } else {
            publishedDate = nil
        }
        description = try volumeInfoContainer.decodeIfPresent(String.self, forKey: .description)
        
        // Es posible que no haya imageLinkContainer, entonces ponemos try? para asegurarnos que está al hacer el decode.
        let imageLinkContainer = try? volumeInfoContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageLinks)
        coverURL = try imageLinkContainer?.decodeIfPresent(URL.self, forKey: .coverURL)
        
        rating = try volumeInfoContainer.decodeIfPresent(Float.self, forKey: .rating)
        numberOfReviews = try volumeInfoContainer.decodeIfPresent(Int.self, forKey: .numberOfReviews)
        
        let saleInfoContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .saleInfo)
        let listPriceContainer = try? saleInfoContainer?.nestedContainer(keyedBy: CodingKeys.self, forKey: .listPrice)
        price = try listPriceContainer??.decodeIfPresent(Float.self, forKey: .price)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bookId, forKey: .bookId)
        
        var volumeInfoContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        try volumeInfoContainer.encode(title, forKey: .title)
        try volumeInfoContainer.encodeIfPresent(authors, forKey: .authors)
        if let date = publishedDate {
            try volumeInfoContainer.encode(DateFormatter.booksDateFormatter.string(from: date), forKey: .publishedDate)
        }
        try volumeInfoContainer.encodeIfPresent(description, forKey: .description)
        
        var imageLinksContainer = volumeInfoContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageLinks)
        try imageLinksContainer.encodeIfPresent(coverURL, forKey: .coverURL)
        
        try volumeInfoContainer.encodeIfPresent(rating, forKey: .rating)
        try volumeInfoContainer.encodeIfPresent(numberOfReviews, forKey: .numberOfReviews)
        
        var saleInfoContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .saleInfo)
        var listPriceContainer = saleInfoContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .listPrice)
        try listPriceContainer.encodeIfPresent(price, forKey: .price)
        
    }
    
}

extension Book: MediaItemProvidable {
    
    var mediaItemId: String {
        return bookId
    }
    
    var imageURL: URL? {
        return coverURL
    }
    
}

extension Book: MediaItemDetailedProvidable {
    
    var creatorName: String? {
        return authors?.joined(separator: ", ") // [Patrick, Juan] ->  "Patrick, Juan"
    }
    
    var creationDate: Date? {
        return publishedDate
    }
    
    var gender: String? {
        return nil
    }
    
}
