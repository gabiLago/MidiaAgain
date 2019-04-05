//
//  BookCollection.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

struct BookCollection {
    
    let kind: String
    let totalItems: Int
    let items: [Book]?
    
}

extension BookCollection: Decodable {
    
}
