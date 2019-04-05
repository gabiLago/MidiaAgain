//
//  MovieManaged+Mapping.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

extension MovieManaged {
    
    func mappedObject() -> Movie {
        
        let url: URL? = movieCoverUrl != nil ? URL(string: movieCoverUrl!) : nil
        let gender: String!
        if movieGender != nil {
            gender = movieGender
        } else {
            gender = ""
        }
        
        return Movie(
            movieId: movieId!,
            name: movieName!,
            director: movieDirector!,
            releaseDate: releaseDate!,
            description: movieDescription!,
            coverURL: url!,
            price: moviePrice,
            gender: gender
        )
    }
}

