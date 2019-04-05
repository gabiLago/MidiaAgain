//
//  MediaItemProviderTests.swift
//  MidiaTests
//
//  Created by Gabriel Lago Blasco on 3/4/19.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import XCTest
@testable import MidiaAgain

class MockMediaItemAPIConsumer: MediaItemAPIConsumable {
    
    func getLatestMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                success([MockMediaItem(), MockMediaItem()])
            }
        }
    }
    
    func getMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        success([MockMediaItem(), MockMediaItem()])
    }
    
    func getMediaItem(byId mediaItemId: String, success: @escaping (MediaItemDetailedProvidable) -> Void, failure: @escaping (Error?) -> Void) {
        failure(nil)
    }
    
}

struct MockMediaItem: MediaItemProvidable {
    var mediaItemId: String = "1"
    var title: String = "A title"
    var imageURL: URL? = nil
}


class MediaItemProviderTests: XCTestCase {
    
    var mediaItemProvider: MediaItemProvider!
    var mockConsumer = MockMediaItemAPIConsumer()
    
    override func setUp() {
        super.setUp()
        
        mediaItemProvider = MediaItemProvider(withMediaItemKind: .book, apiConsumer: mockConsumer)
    }
    
    func testGetHomeMediaItems() {
        mediaItemProvider.getHomeMediaItems(onSuccess: { (mediaItems) in
            XCTAssertNotNil(mediaItems)
            XCTAssert(mediaItems.count > 0)
            XCTAssertNotNil(mediaItems.first?.title)
        }) { (_) in
            XCTFail()
        }
    }
    
}
