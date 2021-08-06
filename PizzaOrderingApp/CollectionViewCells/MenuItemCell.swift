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

  lazy var priceLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 22)
      label.textColor = .secondaryLabel
      return label
  }()

  lazy var plusButton: UIButton = {
    let button = UIButton()
    let icon = UIImage(systemName: "plus")
    button.setImage(icon, for: .normal)
    button.backgroundColor = .systemRed
    button.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
    return button
  }()

  lazy var minusButton: UIButton = {
    let button = UIButton()
    let icon = UIImage(systemName: "minus")
    button.setImage(icon, for: .normal)
    button.backgroundColor = .systemRed
    return button
  }()

  lazy var amountLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  func configure(with item: MenuItem) {
    nameLabel.text = item.name
    priceLabel.text = String(item.price) + ":-"
    if let amount = item.amount {
      amountLabel.text = "x\(amount)"
    } else {
      amountLabel.text = "x0"
    }
    setupView()
  }

  @objc func buttonTouched(){
    print("PRESSED")
  }

  private func setupView() {

    backgroundColor = .systemBlue
    layer.cornerRadius = 8
    clipsToBounds = true
    addSubview(nameLabel)
    addSubview(priceLabel)
    addSubview(amountLabel)

    nameLabel.edgesToSuperview(excluding: .trailing, insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    priceLabel.leadingToTrailing(of: nameLabel, offset: 8)
    priceLabel.centerY(to: nameLabel)
    amountLabel.centerY(to: nameLabel)
    amountLabel.edgesToSuperview(excluding: .leading, insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
  }
}
