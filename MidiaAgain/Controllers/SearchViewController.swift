//
//  SearchViewController.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    
    let mediaItemCellReuseIdentifier = "mediaItemCellIdentifier"
    var mediaItemKind: MediaItemKind = startingMediaItemKind
    
    // MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    //    var mediaItemProvider: MediaItemProvider!
    var mediaItemProvider = MediaItemProvider(withMediaItemKind: .book)
    var mediaItems: [MediaItemProvidable] = []
    var bkImage: UIImage = UIImage(named: "moviesMidia")!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = bkImage
        
    }
    
    // MARK: Actions
    @IBAction func booksTapped(_ sender: Any) {
        mediaItemProvider = MediaItemProvider(withMediaItemKind: .book)
        self.mediaItemKind = .book
        bkImage = UIImage(named: "booksMidia")!
        backgroundImage.image = bkImage
    }
    
    @IBAction func MoviesTapped(_ sender: Any) {
        mediaItemProvider = MediaItemProvider(withMediaItemKind: .movie)
        self.mediaItemKind = .movie
        bkImage = UIImage(named: "moviesMidia")!
        backgroundImage.image = bkImage
    }
    @IBAction func GamesTapped(_ sender: Any) {
        bkImage = UIImage(named: "gamesMidia")!
        backgroundImage.image = bkImage
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            fatalError()
        }
        
        let mediaItem = mediaItems[indexPath.item]
        detailViewController.mediaItemId = mediaItem.mediaItemId
        detailViewController.mediaItemProvider = mediaItemProvider
        detailViewController.mediaItemKind = mediaItemKind
        present(detailViewController, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaItemCellReuseIdentifier, for: indexPath) as? MediaItemCollectionViewCell else {
            fatalError("Unexpected cell type")
        }
        let mediaItem = mediaItems[indexPath.item]
        cell.mediaItem = mediaItem
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let queryParams = searchBar.text, !queryParams.isEmpty else {
            return
        }
        
        activityIndicator.isHidden = false
        mediaItemProvider.getSearchMediaItems(withQueryParams: queryParams, success: { [weak self] (mediaItems) in
            self?.mediaItems = mediaItems
            self?.collectionView.reloadData()
            self?.activityIndicator.isHidden = true
            
        }) { (error) in
            // TODO
        }
    }
    
}



