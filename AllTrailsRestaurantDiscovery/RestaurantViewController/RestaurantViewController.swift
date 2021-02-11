//
//  RestaurantViewController.swift
//  AllTrailsRestaurantDiscovery
//
//  Created by Marisa Feyen on 1/30/21.
//

import UIKit
import CoreLocation



final class RestaurantViewController: UIViewController {
    
    private var shouldShowMap = false
    private var mainStackView = UIStackView()
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var viewModel: RestaurantViewModel
    let monitor = NetworkStatus.shared
        
    private lazy var headerView: RestaurantListHeaderView = {
        let headerView = RestaurantListHeaderView()
        headerView.filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        return headerView
    }()
    
    private lazy var restaurantListViewController: RestaurantListViewController = {
        let controller = RestaurantListViewController(viewModel: viewModel)
        return controller
    }()
    
    private lazy var mapViewController: MapViewController = {
        let controller = MapViewController(viewModel: viewModel)
        return controller
    }()
    
    private lazy var loadingViewController: LoadingViewController = {
        let controller = LoadingViewController()
        return controller
    }()
    
    private lazy var toggleButton: ToggleButton = {
        let toggle = ToggleButton()
        toggle.shouldShowMap = false
        toggle.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)
        return toggle
    }()
    
    init(viewModel: RestaurantViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK : LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addConstraints()
        setupLocationManager()
        addContentController(loadingViewController, to: mainStackView)
        
        monitorNetworkConnectivity()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.layoutIfNeeded()
    }
    
    func loadContent() {
        guard let coordinate = currentLocation?.coordinate else { return }
        let location = LocationParameters(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude), radius: String(1000))
        let queryParameters = QueryParameters(location: location, nextPageToken: nil)
        viewModel.fetchNearbyPlaces(queryParameters: queryParameters) { [weak self] error in
            
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    let alert = RestaurantDiscoveryAlerts.getAlertController(for: error)
                    self.present(alert, animated: false, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.removeContentController(self.loadingViewController)
                    self.addContentController(self.restaurantListViewController, to: self.mainStackView)
                }
            }
        }
    }
    
    private func updateUserInteraction(_ isUserInteractionEnabled: Bool) {
        toggleButton.isUserInteractionEnabled = isUserInteractionEnabled
        headerView.filterButton.isUserInteractionEnabled = isUserInteractionEnabled
        headerView.textFieldContainer.textField.isUserInteractionEnabled = isUserInteractionEnabled

    }
    
    private func setup() {
        headerView.textFieldContainer.textField.delegate = self
        view.backgroundColor = UIColor.white
        mainStackView = VerticalStackView(arrangedSubviews: [headerView])
        toggleButton.adjustsImageWhenHighlighted = false
        view.addSubview(mainStackView)
        view.addSubview(toggleButton)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func addConstraints() {
        headerView.constrainHeight(constant: 134)
        headerView.constrainWidth(constant: view.frame.size.width)
        
        toggleButton.centerHorizontallyInView()
        toggleButton.constrainHeight(constant: 42)
        toggleButton.constrainWidth(constant: 100)
        mainStackView.fillSuperview()
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toggleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46)
         ])
    }
    
    private func addContentController(_ child: UIViewController, to stackView: UIStackView) {
        if child is LoadingViewController {
            updateUserInteraction(false)
        }
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    private func removeContentController(_ child: UIViewController) {
        if child is LoadingViewController {
            updateUserInteraction(true)
        }
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    @objc private func toggleButtonPressed() {
        if let child = children.first {
            removeContentController(child)
        }
        
        shouldShowMap.toggle()
        let child = shouldShowMap ? mapViewController : restaurantListViewController
        addContentController(child, to: mainStackView)
        toggleButton.shouldShowMap.toggle()
        toggleButton.updateConstraints(shouldShowMap: shouldShowMap)
    }
    
    @objc private func filterButtonPressed() {
        guard let text = headerView.textFieldContainer.textField.text else { return }
        viewModel.updateFilterParameter(to: text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: Network connectivity function
    func monitorNetworkConnectivity() {
        monitor.startMonitoring()

        monitor.networkStatusChangeHandler = {
            if !self.monitor.isConnected {
                DispatchQueue.main.async { [unowned self] in
                    let alertController = RestaurantDiscoveryAlerts.networkError()
                    self.present(alertController, animated: true, completion: nil)
                }
            }
       }
    }
}

extension RestaurantViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        self.currentLocation = currentLocation
        self.mapViewController.currentLocation = currentLocation
        loadContent()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
      if status == .authorizedWhenInUse || status == .authorizedAlways {
        locationManager?.requestLocation()
      }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = RestaurantDiscoveryAlerts.locationError()
        present(alert, animated: false)
    }
}

extension RestaurantViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        filterButtonPressed()
        textField.resignFirstResponder()
        return true
    }
}
