//
//  DetailView.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import UIKit
import TinyConstraints

final class DetailView: UIViewController {

  var currentRestaurant: Restaurant?

  typealias DataSource = UICollectionViewDiffableDataSource<Section, MenuItem>
  typealias DataSourceSnapShot = NSDiffableDataSourceSnapshot<Section, MenuItem>

  var dataSource: DataSource!
  var snapshot = DataSourceSnapShot()
  var apiHandler: ApiHandler?
  var collectionView: UICollectionView! = nil
  var cart: [CartItem] = []
  var readableCart: [ReadableCartItem] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = currentRestaurant?.name
    apiHandler = ApiHandler()
    configureCollectionViewLayout()
    configureCollectionViewDataSource()
    downloadMenu(id: currentRestaurant?.id ?? 0)
    addBarButton()

  }

  override func viewDidAppear(_ animated: Bool) {
    cart = []
    readableCart = []
    navigationItem.rightBarButtonItem?.isEnabled = false

    for cell in collectionView.visibleCells {
      cell.backgroundColor = .systemBlue
    }
  }

  @objc func order(sender: UIButton!){
    if cart.isEmpty {
      return
    } else {
      print(cart)
      var nextVC = OrderView()
      nextVC.cart = cart
      nextVC.readableCart = readableCart
      nextVC.currentRestaurant = currentRestaurant
      self.navigationController?.pushViewController(nextVC, animated: true)
    }
  }

  func addBarButton(){
    let button: UIButton = UIButton(type: .custom) 
    button.setImage(UIImage(systemName: "cart.fill"), for: .normal)
    button.addTarget(self, action: #selector(order), for: .touchUpInside)
    let barButton = UIBarButtonItem(customView: button)
    self.navigationItem.rightBarButtonItem = barButton
    self.navigationItem.rightBarButtonItem?.isEnabled = false
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
    guard var chosenItem = dataSource.itemIdentifier(for: indexPath) else { return }
    var itemToCart = CartItem(menuItemId: chosenItem.id, quantity: 1)
    var readableToCart = ReadableCartItem(name: chosenItem.name, quantity: 1)
    for item in cart {
      if item.menuItemId == chosenItem.id {
        itemToCart.quantity = item.quantity + 1
        cart.removeAll { CartItem in
          CartItem.menuItemId == chosenItem.id
        }
      }
    }
    for item in readableCart {
      if item.name == chosenItem.name {
        readableToCart.quantity = item.quantity + 1
        readableCart.removeAll { ReadableCartItem in
          ReadableCartItem.name == chosenItem.name
        }
      }
    }
    if chosenItem.amount == nil {
      chosenItem.amount = 1
    } else {
      chosenItem.amount = chosenItem.amount! + 1
    }
    cart.append(itemToCart)
    readableCart.append(readableToCart)
    navigationItem.rightBarButtonItem?.isEnabled = true
    print(readableCart)
  }

  func configureCollectionViewLayout() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.delegate = self
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.reuseIdentifier)
    view.addSubview(collectionView)
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

  func configureCollectionViewDataSource() {
    dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, item) -> MenuItemCell? in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: MenuItemCell.reuseIdentifier, for: indexPath) as! MenuItemCell
        cell.configure(with: item)
        return cell
      })
  }

  func applySnapshot(items: [MenuItem]) {
    print("APPLY SNAPSHOT")
    snapshot = DataSourceSnapShot()
    snapshot.appendSections([Section.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot)
  }

  func createDummyData() -> [MenuItem] {
    var dummyData: [MenuItem] = []
    for i in 0..<3 {
      dummyData.append(
        MenuItem(id: i, category: "?", name: "?", price: 0, rank: i)
      )
    }
    return dummyData
  }
}
