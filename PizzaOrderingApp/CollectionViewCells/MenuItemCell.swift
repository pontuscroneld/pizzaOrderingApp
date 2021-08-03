//
//  MenuItemCell.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import UIKit
import TinyConstraints

class MenuItemCell: UICollectionViewCell, SelfConfiguringCell {
  static let reuseIdentifier: String = "menuCell"

  override init(frame: CGRect) {
      super.init(frame: frame)

  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  lazy var nameLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 22)
      label.textColor = .label
      return label
  }()

  func configure(with item: MenuItem) {
    nameLabel.text = item.name

    setupView()
  }

  private func setupView() {

    backgroundColor = .systemBlue
    layer.cornerRadius = 8
    clipsToBounds = true
    addSubview(nameLabel)

    nameLabel.edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8))
  }
}

//var id: Int
//var category: String
//var name: String
//var topping: [String]
//var price: Int
//var rank: Int
