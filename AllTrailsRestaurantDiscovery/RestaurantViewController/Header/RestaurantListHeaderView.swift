//
//  RestaurantListHeaderView.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/30/21.
//

import UIKit

final class RestaurantListHeaderView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "allTrailsLogo")
        logoView.contentMode = .scaleAspectFill
        return logoView
    }()
    
    lazy var title: UILabel = {
        let title = UILabel.init(text: "at Lunch", font: UIFont.light(size: 24))
        title.textColor = UIColor.tertiaryGray()
        return title
    }()
    
    lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setTitleColor(UIColor.quaternaryGray(), for: .normal)
        filterButton.titleLabel?.font = UIFont.light(size: 12)
        
        filterButton.layer.cornerRadius = 6
        filterButton.layer.borderColor = UIColor.secondaryGray().cgColor
        filterButton.layer.borderWidth = 1
        
        return filterButton
    }()
    
    lazy var textFieldContainer: RestaurantTextFieldContainer = {
        let filterTextField = FilterTextField()
        
        filterTextField.layer.cornerRadius = 6
        filterTextField.layer.borderWidth = 1
        filterTextField.layer.borderColor = UIColor.secondaryGray().cgColor
        filterTextField.backgroundColor = UIColor.white
        filterTextField.textColor = UIColor.black
        filterTextField.attributedPlaceholder = NSAttributedString(string: "Search for a restaurant", attributes: [.font: UIFont.bold(size: 12), .foregroundColor: UIColor.quaternaryGray()])
        filterTextField.leftView = nil
        filterTextField.rightView = UIImageView(image: UIImage(named: "search"))
        filterTextField.returnKeyType = .done

        let textFieldContainer = RestaurantTextFieldContainer(filterTextField, radius: 2, color: .black, offset: CGSize(width: 0, height: 2), opacity: 0.2, cornerRadius: 6)
        
        return textFieldContainer
    }()
    
    func setup() {
        self.backgroundColor = .white
    
        addSubview(filterButton)
        addSubview(textFieldContainer)
        
    }
    
    private func addConstraints() {
        
        let titleStackView = HorizontalStackView(arrangedSubviews: [logoView, title], spacing: 4)
        titleStackView.alignment = .center
    
        addSubview(titleStackView)
        
        logoView.constrainWidth(constant: 120)
        logoView.constrainHeight(constant: 22.4)
        filterButton.constrainWidth(constant: 52)
        filterButton.constrainHeight(constant: 32)
        textFieldContainer.constrainHeight(constant: 32)
        textFieldContainer.constrainWidth(constant: UIScreen.main.bounds.width - 2*32 - 52 - 8)
        titleStackView.centerHorizontallyInView()
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 48),
            filterButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 86),
            filterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            textFieldContainer.topAnchor.constraint(equalTo: topAnchor, constant: 86),
            textFieldContainer.leadingAnchor.constraint(equalTo: filterButton.trailingAnchor, constant: 8)
        ])
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        textFieldContainer.textField.rightViewMode = .unlessEditing
        textFieldContainer.layer.shadowPath = UIBezierPath(rect: textFieldContainer.bounds).cgPath
        textFieldContainer.layer.shadowRadius = 2
        textFieldContainer.layer.shadowColor = UIColor.black.cgColor
        textFieldContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        textFieldContainer.layer.shadowOpacity = 0.1
    }
    
}
