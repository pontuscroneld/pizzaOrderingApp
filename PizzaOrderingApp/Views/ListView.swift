//
//  ListView.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import UIKit
import CoreLocation

class ListView: UIViewController {

  typealias DataSource = UICollectionViewDiffableDataSource<Section, Restaurant>
  typealias DataSourceSnapShot = NSDiffableDataSourceSnapshot<Section, Restaurant>

  var dataSource: DataSource!
  var snapshot = DataSourceSnapShot()
  var userLocation: CLLocation?

  var locationManager: CLLocationManager?
  var apiHandler: ApiHandler?
  var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
      
      navigationItem.title = "Pizza places"
      findLocation()
    }

  func goConfigure(){
    apiHandler = ApiHandler()
    configureCollectionViewLayout()
    configureCollectionViewDataSource()
    downloadRestaurants()
  }

  func downloadRestaurants(){
    guard let userLocation = userLocation else { return }
    apiHandler?.userLocation = userLocation
    self.apiHandler?.loadRestaurants() { [weak self] result in
      DispatchQueue.main.async {
          switch result {
          case let .success(downloaded):
            self?.applySnapshot(restaurants: downloaded)
          case .failure(_):
            self?.applySnapshot(restaurants: (self?.createDummyData())!)
          }
      }
    }
  }

  func findLocation(){
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestWhenInUseAuthorization()
  }
}

// MARK: - Collection View, Location Delegate
extension ListView: UICollectionViewDelegate, CLLocationManagerDelegate {

  enum Section {
    case main
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locationManager?.requestLocation()
    }
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    if let location = locations.first {
      let latitude = location.coordinate.latitude
      let longitude = location.coordinate.longitude
      userLocation = CLLocation(latitude: latitude, longitude: longitude)
      print(userLocation)
      goConfigure()
    }
  }

  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print("Could not find user location. Assigning location to preset coordinates.")
    userLocation = CLLocation(latitude: 59.192340, longitude: 18.031080)
    goConfigure()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let chosenRestaurant = dataSource.itemIdentifier(for: indexPath) else { return }
    print(chosenRestaurant.name)
    var nextVC = DetailView()
    nextVC.currentRestaurant = chosenRestaurant
    self.navigationController?.pushViewController(nextVC, animated: true)
  }

  func createLayout() -> UICollectionViewLayout {
    print("Create layout")
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(76))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }

  func configureCollectionViewLayout() {
    print("Config layout")
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.delegate = self
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(RestaurantListCell.self, forCellWithReuseIdentifier: RestaurantListCell.reuseIdentifier)
    view.addSubview(collectionView)
  }

  func configureCollectionViewDataSource() {
    print("Config data source")
    dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, restaurant) -> RestaurantListCell? in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: RestaurantListCell.reuseIdentifier, for: indexPath) as! RestaurantListCell
        cell.configure(with: restaurant)
        return cell
      })
  }

  func createDummyData() -> [Restaurant] {
    var dummyData: [Restaurant] = []
    for i in 0..<3 {
      dummyData.append(
        Restaurant(
          id: i,
          name: "Unknown Restaurant",
          address1: "",
          address2: "",
          latitude: Double(i),
          longitude: Double(i))
      )
    }
    return dummyData
  }

  func applySnapshot(restaurants: [Restaurant]) {
    print("APPLY SNAPSHOT")
    snapshot = DataSourceSnapShot()
    snapshot.appendSections([Section.main])
    snapshot.appendItems(restaurants)
    dataSource.apply(snapshot)
  }
}
