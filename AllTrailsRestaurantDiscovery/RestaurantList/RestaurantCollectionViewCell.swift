//
//  RestaurantCollectionViewCell.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/30/21.
//

import UIKit

final class RestaurantCollectionViewCell: UICollectionViewCell {
    
    var favoriteButton = UIButton()
    var isFavorited = false
    
    static func cellID() -> String {
        return String(describing: self)
    }
    
    static func classRegistrationData() -> CellClassRegistrationData {
        return (self, self.cellID())
    }
    
    let detailsView = RestaurantDetailsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryGray().cgColor
        layer.masksToBounds = true
        backgroundColor = .white
        
        addSubview(detailsView)
        addSubview(favoriteButton)
        addConstraints()
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private func addConstraints() {
        
        detailsView.constrainHeight(constant: 100)
        favoriteButton.constrainHeight(constant: 20)
        favoriteButton.constrainWidth(constant: 22)
        
        NSLayoutConstraint.activate([
            detailsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            detailsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -54),
            detailsView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setFavoriteButtonImage() {
        let imageName = isFavorited ? "Favorite" : "Unfavorite"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc func favoriteButtonTapped(sender: UIButton) {
        isFavorited.toggle()
        setFavoriteButtonImage()
       
        if let superview = self.superview as? UICollectionView {
            superview.convert(sender.center, from: sender.superview)
            guard let index = superview.indexPath(for: self)?.row else { return }
            if let dataSource = superview.dataSource as? RestaurantListCollectionViewManager {
                dataSource.didFavorite(index: index, isFavorite: isFavorited)
            }
        }
    }
    
    func configure(restaurant: Restaurant) {
        detailsView.configure(restaurant: restaurant)
        //favorite
        let imageName = restaurant.isFavorite ? "Favorite" : "Unfavorite"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal) 
    }
}
