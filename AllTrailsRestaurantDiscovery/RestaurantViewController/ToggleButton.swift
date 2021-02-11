//
//  ToggleButton.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/31/21.
//

import UIKit

final class ToggleButton: UIButton {
    
    var imageWidthConstraint: NSLayoutConstraint!
    var imageHeightConstraint: NSLayoutConstraint!
    
    init(){
        super.init(frame: .zero)
        setup()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var shouldShowMap = false {
        didSet {
            setButtonState()
        }
    }
    
    private func setButtonState() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 20
        let title = shouldShowMap ? "List" : "Map"
        let attributedTitle = NSAttributedString(string: title, attributes: [.paragraphStyle: paragraphStyle, .foregroundColor : UIColor.white])
        
        let image = shouldShowMap ? UIImage(named: "List") : UIImage(named: "Pin")
        setImage(image, for: .normal)
        setAttributedTitle(attributedTitle, for: .normal)
    }
    
    private func setup() {
        backgroundColor = UIColor.green()
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.bold(size: 14)
    }
    
    func addConstraints() {

        if let imageView = imageView, let titleLabel = titleLabel {
            
            imageWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 14)
            self.addConstraint(imageWidthConstraint)
            imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 19)
            self.addConstraint(imageHeightConstraint)
            
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
            ])
            
            imageEdgeInsets = UIEdgeInsets.zero
            updateInsets(shouldShowMap: false)
            
            layoutIfNeeded()
        }
    }
    
    func updateInsets(shouldShowMap: Bool) {
        let spacing:CGFloat = shouldShowMap ? 8 : 6
        titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
        contentEdgeInsets = UIEdgeInsets(top: 13, left: 23, bottom: 13, right: 23 + spacing)
    }
    
    func updateConstraints(shouldShowMap: Bool) {
        let widthAnchor:CGFloat = shouldShowMap ? 17 : 14
        let heightAnchor:CGFloat = shouldShowMap ? 16 : 19
        
        imageWidthConstraint.constant = widthAnchor
        imageHeightConstraint.constant = heightAnchor
        updateInsets(shouldShowMap: shouldShowMap)
    }
}
