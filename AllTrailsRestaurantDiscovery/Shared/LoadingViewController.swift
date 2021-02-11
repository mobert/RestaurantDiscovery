//
//  LoadingViewController.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import UIKit

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor()
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .black
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.fillSuperview()

    }
}
