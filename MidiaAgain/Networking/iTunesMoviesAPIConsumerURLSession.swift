//
//  iTunesMoviesAPIConsumerURLSession.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

class iTunesMoviesAPIConsumerURLSession: MediaItemAPIConsumable {
    
    let session = URLSession.shared
    
    func getLatestMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        let url = iTunesMoviesAPIConstants.getAbsoluteURL(withQueryParams: ["Lost"])
        let task = session.dataTask(with: url) { (data, response, error) in
            // Si hay error, lo paso para arriba con la closure de failure
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movieCollection = try decoder.decode(MovieCollection.self, from: data)
                    DispatchQueue.main.async { success(movieCollection.results ?? []) }
                } catch {
                    DispatchQueue.main.async { failure(error) }
                }
                
            } else {
                DispatchQueue.main.async { success([]) }
            }
        }
        task.resume()
    }
    
    func getMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        let url = iTunesMoviesAPIConstants.getAbsoluteURL(withQueryParams: [queryParams])
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movieCollection = try decoder.decode(MovieCollection.self, from: data)
                    DispatchQueue.main.async { success(movieCollection.results ?? []) }
                } catch {
                    DispatchQueue.main.async { failure(error) }
                }
            } else {
                DispatchQueue.main.async { success([]) }
            }
        }
        task.resume()
    }
    
    func getMediaItem(byId mediaItemId: String, success: @escaping (MediaItemDetailedProvidable) -> Void, failure: @escaping (Error?) -> Void) {
        
        let url = iTunesMoviesAPIConstants.urlForMovie(withId: mediaItemId)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(MovieCollection.self, from: data)
                    guard let movieForDetail = movie.results?.first else { return }
                    DispatchQueue.main.async { success(movieForDetail) }
                } catch {
                    DispatchQueue.main.async { failure(error) }
                }
            }
        }
        task.resume()
    }
    
}

