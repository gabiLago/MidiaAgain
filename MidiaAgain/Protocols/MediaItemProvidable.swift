//
//  MediaItemProvidable.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import Foundation

protocol MediaItemProvidable {
    
    var mediaItemId: String { get }
    var title: String { get }
    var imageURL: URL? { get }
    
}
