//
//  GoogleBooksAPIConsumerURLSession.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

class GoogleBooksAPIConsumerURLSession: MediaItemAPIConsumable {
    
    let session = URLSession.shared
    
    func getLatestMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        let url = GoogleBooksAPIConstants.getAbsoluteURL(withQueryParams: ["iOS"])
        let task = session.dataTask(with: url) { (data, response, error) in
            // Si hay error, lo paso para arriba con la closure de failure
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let bookCollection = try decoder.decode(BookCollection.self, from: data)
                    DispatchQueue.main.async { success(bookCollection.items ?? []) }
                } catch {
                    DispatchQueue.main.async { failure(error) } // Error parseando, lo enviamos para arriba
                }
            } else {
                DispatchQueue.main.async { success([]) }
            }
        }
        task.resume()
    }
    
    func getMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        let url = GoogleBooksAPIConstants.getAbsoluteURL(withQueryParams: [queryParams])
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let bookCollection = try decoder.decode(BookCollection.self, from: data)
                    DispatchQueue.main.async { success(bookCollection.items ?? []) }
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
        let url = GoogleBooksAPIConstants.urlForBook(withId: mediaItemId)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let book = try decoder.decode(Book.self, from: data)
                    DispatchQueue.main.async { success(book) }
                } catch {
                    DispatchQueue.main.async { failure(error) }
                }
            }
        }
        task.resume()
        
    }
}

