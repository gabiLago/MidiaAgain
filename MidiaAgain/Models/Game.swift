//
//  Game.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

struct Game: MediaItemProvidable, MediaItemDetailedProvidable {
    
    let mediaItemId: String = "1245"
    let title: String = "A game"
    let imageURL: URL? = nil
    let creatorName: String? = nil
    let rating: Float? = nil
    let numberOfReviews: Int? = nil
    let creationDate: Date? = nil
    let price: Float? = nil
    let description: String? = nil
    let mediaItemKind: MediaItemKind? = nil
    let gender: String? = nil
}
