//
//  RestaurantSearchBarContainer.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/31/21.
//

import UIKit

final class RestaurantTextFieldContainer: UIView {
    
    var textField: FilterTextField
    
    init(_ textField: FilterTextField, radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float, cornerRadius: CGFloat) {
        self.textField = textField
        super.init(frame: .zero)

        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.masksToBounds = false
        
        textField.layer.cornerRadius = cornerRadius
        textField.clipsToBounds = true
        
        addSubview(textField)
        textField.fillSuperview()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


