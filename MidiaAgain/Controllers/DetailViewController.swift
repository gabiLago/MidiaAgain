//
//  DetailViewController.swift
//  MidiaAgain
//
//  Created by Gabriel Lago Blasco on 05/04/2019.
//  Copyright © 2019 Gabi Lago Blasco. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var numberOfReviews: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var creatorsLabel: UILabel!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var ratingsContainerView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var toggleFavoriteButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    
    var mediaItemKind: MediaItemKind!
    var mediaItemId: String!
    var mediaItemProvider: MediaItemProvider! // debería ser opcional
    var detailedMediaItem: MediaItemDetailedProvidable?
    
    var isFavorite: Bool = false
    var favoriteIsOK: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncViewWithModel()
        
        loadingView.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if(mediaItemKind == .book){
            
            if let favorite = StorageManager.sharedBook.getFavorite(byId: mediaItemId){
                favoriteIsOK = true
                detailedMediaItem = favorite
            }
        } else {
            if let favorite = StorageManager.sharedMovie.getFavorite(byId: mediaItemId){
                favoriteIsOK = true
                detailedMediaItem = favorite
            }
        }
        
        if(favoriteIsOK){
            syncViewWithModel()
            
            loadingView.isHidden = true
            isFavorite = true
            toggleFavoriteButton.setTitle("Remove favorite", for: .normal)
            
        } else {
            mediaItemProvider.getMediaItem(byId: mediaItemId, success: { [weak self] (detailedMediaItem) in
                self?.loadingView.isHidden = true
                self?.detailedMediaItem = detailedMediaItem
                self?.syncViewWithModel()
            }) { [weak self] (error) in
                self?.loadingView.isHidden = true
                // Creo una alerta, le añado acción con handler, presento la alerta
                let alertController = UIAlertController(title: nil, message: "Error recuperando media item.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self?.dismiss(animated: true, completion: nil)
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    private func syncViewWithModel() {
        guard let mediaItem = detailedMediaItem else {
            return
        }
        
        // Obligatorio
        titleLabel.text = mediaItem.title
        
        // Me vale que sea nil
        descriptionTextView.text = mediaItem.description
        
        if let url = mediaItem.imageURL {
            imageView.loadImage(fromURL: url)
        }
        
        // Stack view, si lo tenemos lo pintamos, si no ocultamos el elemento para que la stack view reorganice
        if let creators = mediaItem.creatorName {
            creatorsLabel.text = creators
        } else {
            creatorsLabel.isHidden = true
        }
        
        if let rating = mediaItem.rating,
            let numberOfReviews = mediaItem.numberOfReviews {
            ratingLabel.text = "Rating \(rating)"
            numberOfReviewsLabel.text = "\(numberOfReviews) reviews"
        }  else if let gender = mediaItem.gender {
            ratingLabel.text = "Género: \(gender)"
            numberOfReviewsLabel.text = ""
        } else {
            ratingsContainerView.isHidden = true
        }
        
        if let creationDate = mediaItem.creationDate {
            creationDateLabel.text = DateFormatter.displayDateFormatter.string(from: creationDate)
        } else {
            creationDateLabel.isHidden = true
        }
        
        if let price = mediaItem.price {
            buyButton.setTitle("Buy for \(price)$", for: .normal)
        } else {
            buyButton.isHidden = true
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapToggleFavorite(_ sender: Any) {
        guard let favorite = detailedMediaItem else {
            return
        }
        isFavorite.toggle()
        
        
        if isFavorite {
            if(mediaItemKind == .book) {
                StorageManager.sharedBook.add(favorite: favorite)
            } else {
                StorageManager.sharedMovie.add(favorite: favorite)
            }
            toggleFavoriteButton.setTitle("Remove favorite", for: .normal)
        } else {
            if(mediaItemKind == .book) {
                StorageManager.sharedBook.remove(favoriteWithId: favorite.mediaItemId)
            } else {
                StorageManager.sharedMovie.remove(favoriteWithId: favorite.mediaItemId)
            }
            toggleFavoriteButton.setTitle("Add favorite", for: .normal)
        }
    }
    
}

