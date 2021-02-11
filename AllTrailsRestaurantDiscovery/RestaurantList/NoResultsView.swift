//
//  NoResultsView.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/10/21.
//

import UIKit

class NoResultsView: UIView {
    
    let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(label)
        label.text = "Oops! There are no results that match your search."
        label.font = UIFont.bold(size: 20)
        label.numberOfLines = 0
        label.textColor = UIColor.quaternaryGray()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 200),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
}
