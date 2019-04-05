//
//  FavoritesViewController.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesHeader: UILabel!
    
    let favoriteCellReuseIdentifier = "favoriteCellReuseIdentifier"
    var favorites: [MediaItemDetailedProvidable] = []
    var mediaItemKind: MediaItemKind = startingMediaItemKind
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastSelectedMediaItemKind()
        
        if(mediaItemKind == .book){
            if let storedFavorites = StorageManager.sharedBook.getFavorites() {
                favorites = storedFavorites
                tableView.reloadData()
                favoritesHeader.text = "Favorite Books"
                
            }
        } else {
            if let storedFavorites = StorageManager.sharedMovie.getFavorites() {
                favorites = storedFavorites
                favoritesHeader.text = "Favorite Movies"
                tableView.reloadData()
                
            }
        }
        
        
    }
    
    // UserDefaults to store last mediaItemKind Selected
    func lastSelectedMediaItemKind(){
        let id = UserDefaults.standard.integer(forKey: MEDIA_ITEM_KIND)
        
        if(id == 1) {
            mediaItemKind =  .book
        } else {
            mediaItemKind = .movie
        }
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "newDetail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            fatalError()
        }
        
        let mediaItem = favorites[indexPath.row]
        detailViewController.mediaItemId = mediaItem.mediaItemId
        detailViewController.mediaItemKind = mediaItemKind
        present(detailViewController, animated: true, completion: nil)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: favoriteCellReuseIdentifier) as? FavoriteTableViewCell else {
            fatalError()
        }
        cell.mediaItem = favorites[indexPath.row]
        return cell
    }
}
