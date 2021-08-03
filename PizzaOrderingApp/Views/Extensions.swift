//
//  Extensions.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import Foundation
import UIKit

// MARK: - Collection View Delegate
extension ListView: UICollectionViewDelegate  {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: contact
    }

  private func createLayout() -> UICollectionViewLayout {

    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(76))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }

  private func configureCollectionViewLayout() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.delegate = self
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(RestaurantListCell.self, forCellWithReuseIdentifier: RestaurantListCell.reuseIdentifier)
    view.addSubview(collectionView)
  }

  private func configureCollectionViewDataSource() {
      // TODO: dataSource
  }

  private func createDummyData() {
      var dummyData: [Restaurant] = []
      for i in 0..<10 {
          dummyData.append(
            Restaurant(
              id: i,
              name: "",
              address1: "",
              address2: "",
              latitude: 0.0,
              longitude: 0.0)
          )
      }
    apiHandler?.applySnapshot(restaurants: dummyData)
  }
}
