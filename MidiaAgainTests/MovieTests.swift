//
//  MovieTests.swift
//  MidiaTests
//
//  Created by Gabriel Lago Blasco on 15/03/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import XCTest
@testable import MidiaAgain

class MovieTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var bestMovieEver: Movie!
    let posterUrl = URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Video/v4/63/f4/a5/63f4a5f3-a9b7-a701-18c5-57799e6fcff3/source/100x100bb.jpg")
    
    override func setUp() {
        super.setUp()
        
        bestMovieEver = Movie(movieId: "1", name: "Lost in Translation", director: "Sofia Copola", releaseDate: Date(timeIntervalSinceNow: 123), description: "Scarlett Johanson OMG", coverURL: posterUrl!, price: 12.99, gender: "Comedia")
    }
    
    func testMovieExistence() {
        XCTAssertNotNil(bestMovieEver)
    }
    
    func testDecodeMovieCollection() {

        let path = Bundle(for: type(of: self)).path(forResource: "movie-search-response", ofType: "json")!
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        
        do{
            let movieCollection = try decoder.decode(MovieCollection.self, from: data)
            XCTAssertNotNil(movieCollection)
            
            let firstMovie = movieCollection.results?.first!
            
            XCTAssertNotNil(firstMovie?.movieId)
            XCTAssertNotNil(firstMovie?.name)
            XCTAssertNotNil(firstMovie?.director)
            XCTAssertNotNil(firstMovie?.releaseDate)
            XCTAssertNotNil(firstMovie?.description)
            XCTAssertNotNil(firstMovie?.coverURL)
            XCTAssertNotNil(firstMovie?.price)
            XCTAssertNotNil(firstMovie?.gender)
  
        } catch {
            XCTFail()
        }
    }
    
    func testEncodeMovie() {
        do {
            let movieData = try encoder.encode(bestMovieEver)
            XCTAssertNotNil(movieData)
            
        } catch {
            XCTFail()
        }
    }
    
    
    func testDecodeEncodedDetailedMovie() {
        do {
            let movieData = try encoder.encode(bestMovieEver)
            XCTAssertNotNil(movieData)
 
            let movie = try decoder.decode(Movie.self, from: movieData)
            XCTAssertNotNil(movie)
            XCTAssertNotNil(movie.movieId)
            XCTAssertNotNil(movie.name)
            XCTAssertNotNil(movie.director)
            XCTAssertNotNil(movie.releaseDate)
            XCTAssertNotNil(movie.description)
            XCTAssertNotNil(movie.coverURL)
            XCTAssertNotNil(movie.price)
            XCTAssertNotNil(movie.gender)
        } catch {
            XCTFail()
        }
    }
}
