//
//  iTunesMoviesAPIConsumerAlamofire.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation
import Alamofire

class iTunesMoviesAPIConsumerAlamofire: MediaItemAPIConsumable {
    
    func getLatestMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        Alamofire.request(iTunesMoviesAPIConstants.getAbsoluteURL(withQueryParams: ["Lost"])).responseData { (response) in
            
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let movieCollection = try decoder.decode(MovieCollection.self, from: value)
                    success(movieCollection.results ?? [])
                } catch {
                    failure(error)
                }
            }
        }
    }
    
    func getMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        let paramsList = queryParams.components(separatedBy: " ")
        
        Alamofire.request(iTunesMoviesAPIConstants.getAbsoluteURL(withQueryParams: paramsList)).responseData { (response) in
            
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let movieCollection = try decoder.decode(MovieCollection.self, from: value)
                    success(movieCollection.results ?? [])
                } catch {
                    failure(error)
                }
            }
        }
    }
    
    func getMediaItem(byId mediaItemId: String, success: @escaping (MediaItemDetailedProvidable) -> Void, failure: @escaping (Error?) -> Void) {
        
        Alamofire.request(iTunesMoviesAPIConstants.urlForMovie(withId: mediaItemId)).responseData { (response) in
            
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    
                    
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(MovieCollection.self, from: value)
                    guard let movieForDetail = movie.results?.first else { return }
                    success(movieForDetail)
                } catch {
                    failure(error) // Error parseando, lo enviamos para arriba
                }
            }
        }
    }
    
}


