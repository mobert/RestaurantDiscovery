//
//  Extensions.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/30/21.
//

import UIKit

// MARK: - Layout
extension UIView {
    
    func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInView(size: CGSize = .zero) {
        centerHorizontallyInView()
        centerVerticallyInView()
    }
    
    func centerHorizontallyInView(size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    
    func centerVerticallyInView(size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
}

// MARK: - UIImageView

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

// MARK: - UILabel

extension UILabel {
    convenience init(text: String, font: UIFont, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}


// MARK: - Colors

extension UIColor {
    
    static func quaternaryGray() -> UIColor {
        return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
    }
    
    static func detailsGray() -> UIColor {
        return UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1.0)
    }
    
    static func tertiaryGray() -> UIColor{
        return UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
    }
    
    static func secondaryGray() -> UIColor {
        return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    }
    
    static func primaryGray() -> UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    static func backgroundColor() -> UIColor {
        return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
    }
    
    static func green() -> UIColor {
        return UIColor(red: 66/255, green: 138/255, blue: 19/255, alpha: 1.0)
    }
    
    static func starFill() -> UIColor {
        return UIColor(red: 245/255, green: 210/255, blue: 75/255, alpha: 1.0)
    }
}

// MARK: - Fonts

extension UIFont {
    static func light(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "AppleSDGothicNeo-Bold", size: size) {
            return font
        }
        return UIFont.boldSystemFont(ofSize: size)
    }
}

// MARK: - String

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

// MARK: - DispatchQueue

public extension DispatchQueue {
    
    func runningOnThisQueue(contextStringKey: DispatchSpecificKey<String>) -> Bool {

        guard let someContext = DispatchQueue.getSpecific(key: contextStringKey) else {
            return false
        }
        
        guard let thisContext = getSpecific(key: contextStringKey) else {
            return false
        }
        
        return someContext == thisContext
    }
}




 
