//
//  Constants.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

//
//  Constants.swift
//  Midia
//
//  Created by Gabriel Lago Blasco on 3/4/19.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation


struct GoogleBooksAPIConstants {
    
    static func getAbsoluteURL(withQueryParams queryParams: [String]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/books/v1/volumes"
        
        // Asign Google API Key from Info.plist
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                let apiKey = dict["Google_API_Key"] as! String
                components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
                //                print(apiKey)
            }
        }
        components.queryItems?.append(URLQueryItem(name: "q", value: queryParams.joined(separator: "+")))
        
        return components.url!
        
    }
    
    static func urlForBook(withId bookId: String) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/books/v1/volumes/\(bookId)"
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                let apiKey = dict["Google_API_Key"] as! String
                components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
            }
        }
        return components.url!
    }
}

struct iTunesMoviesAPIConstants {
    
    static func getAbsoluteURL(withQueryParams queryParams: [String]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/search"
        components.queryItems = [URLQueryItem(name: "media", value: "movie")]
        components.queryItems?.append(URLQueryItem(name: "attribute", value: "movieTerm"))
        components.queryItems?.append(URLQueryItem(name: "country", value: "es"))
        components.queryItems?.append(URLQueryItem(name: "term", value: queryParams.joined(separator: "+")))
        
        return components.url!
    }
    
    static func urlForMovie(withId trackId: String) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"
        components.queryItems = [URLQueryItem(name: "id", value: trackId )]
        components.queryItems?.append(URLQueryItem(name: "country", value: "es"))
        
        return components.url!
    }
}

let MEDIA_ITEM_KIND_SELECTED_NAME = "MediaItemKindSelection"
let MEDIA_ITEM_KIND = "MediaItemKind"

let startingMediaItemKind: MediaItemKind = .movie

