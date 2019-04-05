//
//  MovieCollection.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

struct MovieCollection {
    
    let resultCount: Int
    let results: [Movie]?
}

extension MovieCollection: Decodable {
}
