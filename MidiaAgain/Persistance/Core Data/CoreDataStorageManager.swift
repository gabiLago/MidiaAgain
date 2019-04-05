//
//  CoreDataStorageManager.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStorageManager: FavoritesProvidable {
    
    let mediaItemKind: MediaItemKind
    let stack = CoreDataStack.sharedInstance
    
    
    init(withMediaItemKind mediaItemKind: MediaItemKind) {
        self.mediaItemKind = mediaItemKind
    }
    
    func getFavorites() -> [MediaItemDetailedProvidable]? {
        let context = stack.persistentContainer.viewContext
        
        switch (mediaItemKind) {
            
        case .book:
            let fetchRequest: NSFetchRequest<BookManaged> = BookManaged.fetchRequest()
            let dateSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "publishedDate", ascending: true)
            let priceSortDescriptor = NSSortDescriptor(key: "price", ascending: false)
            fetchRequest.sortDescriptors = [dateSortDescriptor, priceSortDescriptor]
            
            do {
                let favorites = try context.fetch(fetchRequest)
                return favorites.map({ $0.mappedObject()})
            } catch {
                assertionFailure("Error fetching media items")
                return nil
            }
            
        case .movie:
            let fetchRequest: NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
            let dateSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "releaseDate", ascending: true)
            let priceSortDescriptor = NSSortDescriptor(key: "moviePrice", ascending: false)
            fetchRequest.sortDescriptors = [dateSortDescriptor, priceSortDescriptor]
            
            do {
                let favorites = try context.fetch(fetchRequest)
                return favorites.map({ $0.mappedObject()})
            } catch {
                assertionFailure("Error fetching media items")
                return nil
            }
            
        default:
            assertionFailure("\(mediaItemKind) media item not yet implemented")
            return nil
        }
    }
    
    func getFavorite(byId favoriteId: String) -> MediaItemDetailedProvidable? {
        
        let context = stack.persistentContainer.viewContext
        
        switch (mediaItemKind) {
            
        case .book:
            let fetchRequest: NSFetchRequest<BookManaged> = BookManaged.fetchRequest()
            let predicate: NSPredicate = NSPredicate(format: "bookId = %@", favoriteId)
            fetchRequest.predicate = predicate
            
            do {
                let favorites = try context.fetch(fetchRequest)
                return favorites.last?.mappedObject()
            } catch {
                assertionFailure("Error fetching media item by id \(favoriteId)")
                return nil
            }
            
        case .movie:
            let fetchRequest: NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
            let predicate: NSPredicate = NSPredicate(format: "movieId = %@", favoriteId)
            fetchRequest.predicate = predicate
            
            do {
                let favorites = try context.fetch(fetchRequest)
                return favorites.last?.mappedObject()
            } catch {
                assertionFailure("Error fetching media item by id \(favoriteId)")
                return nil
            }
            
        default:
            assertionFailure("\(mediaItemKind) media item not yet implemented")
            return nil
        }
    }
    
    
    func add(favorite: MediaItemDetailedProvidable) {
        let context = stack.persistentContainer.viewContext
        
        switch(mediaItemKind) {
        case .book:
            if let book = favorite as? Book {
                let bookManaged = BookManaged(context: context)
                bookManaged.bookId = book.bookId
                bookManaged.bookTitle = book.title
                bookManaged.publishedDate = book.publishedDate
                bookManaged.coverURL = book.coverURL?.absoluteString
                bookManaged.bookDescription = book.description
                if let rating = book.rating {
                    bookManaged.rating = rating
                }
                if let numberOfReviews = book.numberOfReviews {
                    bookManaged.numberOfReviews = Int32(numberOfReviews)
                }
                if let price = book.price {
                    bookManaged.price = price
                }
                book.authors?.forEach({ (authorName) in
                    let author = Author(context: context)
                    author.fullName = authorName
                    bookManaged.addToAuthors(author)
                })
                do {
                    try context.save()
                } catch {
                    assertionFailure("error saving context")
                }
            }
            
        case .movie:
            if let movie = favorite as? Movie {
                let movieManaged = MovieManaged(context: context)
                movieManaged.movieId = movie.movieId
                movieManaged.movieName = movie.name
                movieManaged.releaseDate = movie.releaseDate
                movieManaged.movieCoverUrl = movie.coverURL?.absoluteString
                movieManaged.movieDescription = movie.description
                movieManaged.movieDirector = movie.director
                movieManaged.movieGender = movie.gender
                
                if let price = movie.price {
                    movieManaged.moviePrice = price
                }
                
                do {
                    try context.save()
                } catch {
                    assertionFailure("error saving context")
                }
            }
            
        default:
            fatalError("not supported yet :(")
            
        }
    }
    
    func remove(favoriteWithId favoriteId: String) {
        switch(mediaItemKind) {
        case .book:
            let context = stack.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<BookManaged> = BookManaged.fetchRequest()
            let predicate: NSPredicate = NSPredicate(format: "bookId = %@", favoriteId)
            fetchRequest.predicate = predicate
            do {
                let favorites = try context.fetch(fetchRequest)
                favorites.forEach({ (BookManaged) in
                    context.delete(BookManaged)
                })
                try context.save()
                
            } catch {
                assertionFailure("Error removing media item with id \(favoriteId)")
            }
            
        case .movie:
            let context = stack.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
            let predicate: NSPredicate = NSPredicate(format: "movieId = %@", favoriteId)
            fetchRequest.predicate = predicate
            do {
                let favorites = try context.fetch(fetchRequest)
                favorites.forEach({ (MovieManaged) in
                    context.delete(MovieManaged)
                })
                try context.save()
                
            } catch {
                assertionFailure("Error removing media item with id \(favoriteId)")
            }
            
        default:
            assertionFailure("Media Item Kind not yet implemented")
        }
    }
}

