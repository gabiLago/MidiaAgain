//
//  HomeViewController.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import UIKit

enum MediaItemViewControllerState {
    case loading
    case noResults
    case failure
    case ready
}

protocol HomeViewControllerDelegate: class {
    func homeViewController(_ viewController: HomeViewController,  didSelectMediaItemKind: MediaItemKind)
}

class HomeViewController: UIViewController {
    
    var mediaItemKind: MediaItemKind = startingMediaItemKind
    weak var delegate: HomeViewControllerDelegate?
    var kind: String = "Empty"
    
    let mediaItemCellIdentifier = "mediaItemCell"
    
    var mediaItemProvider: MediaItemProvider!
    private var mediaItems: [MediaItemProvidable] = []
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var failureEmojiLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var yLoSabes: UIImageView!
    
    
    var state: MediaItemViewControllerState = .ready {
        willSet {
            guard state != newValue else { return }
            
            // Ocultamos todas las vistas relacionadas con los estados y después mostramos las que corresponden
            [collectionView, activityIndicatorView, failureEmojiLabel, statusLabel, yLoSabes].forEach { (view) in
                view?.isHidden = true
            }
            
            switch newValue {
            case .loading:
                activityIndicatorView.isHidden = false
            case .noResults:
                failureEmojiLabel.isHidden = false
                failureEmojiLabel.text = "☹️"
                statusLabel.isHidden = false
                statusLabel.text = "No hay nada que mostrar!!"
            case .failure:
                failureEmojiLabel.isHidden = false
                failureEmojiLabel.text = "❌"
                statusLabel.isHidden = false
                statusLabel.text = "Error conectando!!"
            case .ready:
                collectionView.isHidden = false
                collectionView.reloadData()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        state = .loading
        syncItemsWithData()
    }
    
    func syncItemsWithData() {
        mediaItemProvider.getHomeMediaItems(onSuccess: { [weak self] (mediaItems) in
            self?.mediaItems = mediaItems
            self?.state = mediaItems.count > 0 ? .ready : .noResults
            self?.collectionView.reloadData()
            
        }) { [weak self] (error) in
            self?.state = .failure
            self?.showSimpleAlert()
            
        }
        self.sendNotification(with: mediaItemKind)
    }
    
    // Show alert if failure in the google API Connection... we'are asuming that the fail is because the API key
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Google API Key", message: "You need to add a valid API Key to access Books. There´s room for that in info.plist. You'll find more info on how to do it in the README.md file.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "❌", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendNotification(with mediaItemKind: MediaItemKind){
        NotificationCenter.default.post(name: Notification.Name(MEDIA_ITEM_KIND_SELECTED_NAME), object: self, userInfo: [MEDIA_ITEM_KIND: mediaItemKind])
    }
    
    // Action Buttons for mediaItemKind selection
    @IBAction func booksButton(_ sender: Any) {
        yLoSabes.isHidden = true
        collectionView.isHidden = false
        mediaItemKind = .book
        mediaItemProvider = MediaItemProvider(withMediaItemKind: mediaItemKind)
        syncItemsWithData()
        saveLastMediaItemKind(id: 1)
    }
    
    @IBAction func moviesAction(_ sender: Any) {
        yLoSabes.isHidden = true
        collectionView.isHidden = false
        mediaItemKind = .movie
        mediaItemProvider = MediaItemProvider(withMediaItemKind: mediaItemKind)
        syncItemsWithData()
        saveLastMediaItemKind(id: 2)
    }
    
    @IBAction func gamesButton(_ sender: Any) {
        yLoSabes.isHidden = false
        collectionView.isHidden = true
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let detailViewController = UIStoryboard(name: "newDetail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            fatalError()
        }
        let mediaItem = mediaItems[indexPath.item]
        detailViewController.mediaItemId = mediaItem.mediaItemId
        detailViewController.mediaItemProvider = mediaItemProvider
        detailViewController.mediaItemKind = mediaItemKind
        
        present(detailViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaItemCellIdentifier, for: indexPath) as? MediaItemCollectionViewCell else {
            fatalError()
        }
        let mediaItem = mediaItems[indexPath.item]
        cell.mediaItem = mediaItem
        return cell
    }
}

extension HomeViewController {
    func saveLastMediaItemKind(id: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(id, forKey: MEDIA_ITEM_KIND)
        userDefaults.synchronize() // Por si acaso.
    }
    
    func lastSelectedMediaItemKind() -> MediaItemKind{
        let id = UserDefaults.standard.integer(forKey: MEDIA_ITEM_KIND)
        switch(id) {
        case 1:
            return .book
            
        case 2:
            return .movie
            
        default:
            return .movie
        }
    }
}

