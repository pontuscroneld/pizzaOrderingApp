//
//  ListView.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import UIKit

class ListView: UIViewController {

  typealias DataSource = UICollectionViewDiffableDataSource<Section, Restaurant>
  typealias DataSourceSnapShot = NSDiffableDataSourceSnapshot<Section, Restaurant>

  var dataSource: DataSource!
  var snapshot = DataSourceSnapShot()

  var apiHandler: ApiHandler?
  var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

      navigationItem.title = "Pizza places"

      apiHandler = ApiHandler()
      configureCollectionViewLayout()
      configureCollectionViewDataSource()
      downloadRestaurants()
    }

  func downloadRestaurants(){
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
}

// MARK: - Collection View Delegate
extension ListView: UICollectionViewDelegate  {

  enum Section {
      case main
  }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      guard let chosenRestaurant = dataSource.itemIdentifier(for: indexPath) else { return }
      print(chosenRestaurant.name)
    }

  func createLayout() -> UICollectionViewLayout {

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
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.delegate = self
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(RestaurantListCell.self, forCellWithReuseIdentifier: RestaurantListCell.reuseIdentifier)
    view.addSubview(collectionView)
  }

  func configureCollectionViewDataSource() {
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
              latitude: 0.0,
              longitude: 0.0)
          )
      }
    return dummyData
  }

  func applySnapshot(restaurants: [Restaurant]) {
    snapshot = DataSourceSnapShot()
    snapshot.appendSections([Section.main])
    snapshot.appendItems(restaurants)
    dataSource.apply(snapshot)
  }
}
