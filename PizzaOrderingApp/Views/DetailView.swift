//
//  DetailView.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import UIKit

final class DetailView: UIViewController {

  var currentRestaurant: Restaurant?

  typealias DataSource = UICollectionViewDiffableDataSource<Section, MenuItem>
  typealias DataSourceSnapShot = NSDiffableDataSourceSnapshot<Section, MenuItem>

  var dataSource: DataSource!
  var snapshot = DataSourceSnapShot()

  var apiHandler: ApiHandler?
  var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

      navigationItem.title = currentRestaurant?.name

      apiHandler = ApiHandler()
      configureCollectionViewLayout()
      configureCollectionViewDataSource()

      
      downloadMenu(id: currentRestaurant?.id ?? 0)
        // Do any additional setup after loading the view.
    }

  func downloadMenu(id: Int){
    self.apiHandler?.loadMenu(id: id) { [weak self] result in
      DispatchQueue.main.async {
          switch result {
          case let .success(downloaded):
            print("Success downloading menu")
            print(downloaded)
            self?.applySnapshot(items: downloaded)
          case .failure(_):
            print("Failure downloading menu")
            self?.applySnapshot(items: (self?.createDummyData())!)
          }
      }
    }
  }
}

  // MARK: - Collection View Delegate
  extension DetailView: UICollectionViewDelegate  {

    enum Section {
        case main
    }

      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chosenItem = dataSource.itemIdentifier(for: indexPath) else { return }
        print(chosenItem.name)
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
      collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifier)
      view.addSubview(collectionView)
    }

    func configureCollectionViewDataSource() {
      print("Config data source")
      dataSource = DataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, item) -> MenuItemCell? in
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as! MenuItemCell
          cell.configure(with: item)
          return cell
        })
    }

    func createDummyData() -> [MenuItem] {
        var dummyData: [MenuItem] = []
        for i in 0..<3 {
            dummyData.append(
              MenuItem(id: i, category: "?", name: "?", topping: ["?"], price: 0, rank: i)
            )
        }
      return dummyData
    }

    func applySnapshot(items: [MenuItem]) {
      print("APPLY SNAPSHOT")
      snapshot = DataSourceSnapShot()
      snapshot.appendSections([Section.main])
      snapshot.appendItems(items)
      dataSource.apply(snapshot)
    }
  }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

