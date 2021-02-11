//
//  RestaurantDetailsView.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/31/21.
//

import UIKit
import Cosmos
import SDWebImage

final class RestaurantDetailsView: UIView {

    var imageView = UIImageView()
    var nameLabel = UILabel()
    var supportingTextLabel = UILabel()
    var priceLevelLabel = UILabel()
    var numberOfReviewsLabel = UILabel()
    var starsView = CosmosView()
        
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .white

        let reviewsStackView = HorizontalStackView(arrangedSubviews: [starsView, numberOfReviewsLabel, UIView()], spacing: 6)
        
        let supportingStackView = HorizontalStackView(arrangedSubviews: [priceLevelLabel, supportingTextLabel, UIView()], spacing: 1)
        let infoStackView = VerticalStackView(arrangedSubviews: [nameLabel, reviewsStackView, supportingStackView], spacing: 3)
        
        let detailsStackView = HorizontalStackView(arrangedSubviews: [imageView, infoStackView], spacing: 16)
        
        addSubview(detailsStackView)
        
        starsView.settings.fillMode = .precise
        starsView.settings.starSize = 16
        starsView.settings.starMargin = 2
        starsView.settings.emptyColor = UIColor.secondaryGray()
        starsView.settings.filledColor = UIColor.starFill()
        starsView.settings.emptyBorderColor = UIColor.clear
        starsView.settings.filledBorderColor = UIColor.clear
        
        starsView.constrainWidth(constant: 88)
        starsView.constrainHeight(constant: 16)
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)

        detailsStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        detailsStackView.alignment = .center
        
        styleViews()
    }
    
    func styleViews() {
        nameLabel.font = UIFont.bold(size: 12)
        nameLabel.textColor = UIColor.quaternaryGray()
        
        numberOfReviewsLabel.font = UIFont.light(size: 12)
        numberOfReviewsLabel.textColor = UIColor.detailsGray()
        
        priceLevelLabel.font = UIFont.light(size: 12)
        priceLevelLabel.textColor = UIColor.detailsGray()
        
        supportingTextLabel.font = UIFont.light(size: 12)
        supportingTextLabel.textColor = UIColor.detailsGray()
    }
    
    func configure(restaurant: Restaurant) {
        
        nameLabel.text = restaurant.name
        
        let rating = restaurant.rating ?? 0
        starsView.rating = rating
        
        let numberOfReviews = restaurant.numberOfReviews
        let numberOfReviewString = numberOfReviews != nil ? String(numberOfReviews!) : "?"
        numberOfReviewsLabel.text = "(\(numberOfReviewString))"
        
        var priceLevelString = ""
        if let priceLevel = restaurant.priceLevel {
            for _ in 0..<priceLevel {
                priceLevelString += "$"
            }
            priceLevelLabel.text = priceLevelString
        }
        
        if let openNow = restaurant.openNow {
            var hours = priceLevelLabel.text == nil ? "" : " • "
            hours += openNow ? "Open now" : "Closed"
            supportingTextLabel.text = hours
        }
        
        if let imageRef = restaurant.imageRef {
            let imageUrl = NetworkService.shared.getPhotoURL(photoReference: imageRef)
            let placeholder = UIImage(named: "placeholder")
            imageView.sd_setImage(with: imageUrl, placeholderImage: placeholder, options: .continueInBackground, context: nil)
        }
    }
}
