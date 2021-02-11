//
//  RestaurantListViewController.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 2/2/21.
//

import UIKit

final class RestaurantListViewController: UIViewController {
    
    fileprivate var collectionViewManager: RestaurantListCollectionViewManager!
    private var viewModel: RestaurantViewModel
    private var noResultsView = NoResultsView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionView.restaurantBlockLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.allowsSelection = false
        
        return collectionView
    }()
    
    init(viewModel: RestaurantViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionViewManager()
        addConstraints()
    }
    
    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(noResultsView)
        noResultsView.isHidden = true
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: placeDataDidUpdateNotification), object: nil, queue: OperationQueue.main) { [weak self] _ in
            guard let self = self else { return }
            self.reloadData()
        }
    }
    
    fileprivate func setupCollectionViewManager() {
        collectionViewManager = RestaurantListCollectionViewManager(dataSource: viewModel, controller: self)
        collectionView.delegate = collectionViewManager
        collectionView.prefetchDataSource = collectionViewManager
        collectionView.dataSource = collectionViewManager
        collectionView.backgroundColor = UIColor.backgroundColor()
        collectionViewManager.registerCellClasses(collectionView, classes: RestaurantListCellRegistrationFactory.standardCellClassRegistrants())
    }
    
    private func addConstraints() {
        let viewWidth = view.bounds.width
        collectionView.constrainWidth(constant: viewWidth)
        collectionView.fillSuperview()
        noResultsView.constrainWidth(constant: viewWidth)
        noResultsView.fillSuperview()
    }
    
    private func reloadData() {
        noResultsView.isHidden = viewModel.restaurants.count > 0 ? true : false
        collectionView.reloadData()
    }
}

extension UICollectionView {
    static func restaurantBlockLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        return layout
    }
}
