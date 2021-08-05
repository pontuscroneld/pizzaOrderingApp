//
//  OrderView.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import UIKit

class OrderView: UIViewController {

  var apiHandler: ApiHandler?
  var readableCart: [ReadableCartItem]?
  var cart: [CartItem]?
  var currentRestaurant: Restaurant?
  var stackView: UIStackView?

  lazy var summaryItem: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.tintColor = .label
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    apiHandler = ApiHandler()
    view.backgroundColor = .systemBackground
    makeStack(items: readableCart!)
    addButtons()
  }

  func makeStack(items: [ReadableCartItem]){

    var views: [UIView] = []
    for item in items {
      print(item.name)
      var newLabel = UILabel()
      newLabel.font = .systemFont(ofSize: 14)
      newLabel.tintColor = .label
      newLabel.text = "\(item.name) x \(item.quantity)"
      newLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
      views.append(newLabel)
    }

    stackView = UIStackView(arrangedSubviews: views)
    stackView!.axis = .vertical
    stackView!.distribution = .fillEqually
    stackView!.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stackView!)

    NSLayoutConstraint.activate([
      stackView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
      stackView!.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      stackView!.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
      stackView!.heightAnchor.constraint(equalToConstant: CGFloat(stackView!.subviews.count * 40))
    ])
  }

  func addButtons() {
    let button = UIButton(type: .system)
    button.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
    button.setTitle("Place Order", for: .normal)
    button.backgroundColor = .systemBlue
    button.tintColor = .white
    button.clipsToBounds = true
    button.layer.cornerRadius = 5
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)

    let resetButton = UIButton(type: .system)
    resetButton.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
    resetButton.setTitle("Delete", for: .normal)
    resetButton.backgroundColor = .systemRed
    resetButton.tintColor = .white
    resetButton.clipsToBounds = true
    resetButton.layer.cornerRadius = 5
    resetButton.translatesAutoresizingMaskIntoConstraints = false
    resetButton.addTarget(self, action: #selector(resetCart), for: .touchUpInside)

    view.addSubview(button)
    view.addSubview(resetButton)

    NSLayoutConstraint.activate([
      button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
      button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      button.heightAnchor.constraint(equalToConstant: 60),
      button.widthAnchor.constraint(equalToConstant: 100),
      resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
      resetButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
      resetButton.heightAnchor.constraint(equalToConstant: 60),
      resetButton.widthAnchor.constraint(equalToConstant: 100),
    ])
  }

  @objc func placeOrder(){
    print("PRESSED ORDER")
    guard let cart = cart else { return }
    guard let res = currentRestaurant else { return }
    apiHandler?.placeOrder(restaurantId: res.id, cart: cart)
  }

  @objc func resetCart(){
    print("PRESSED DELETE")
    stackView?.removeFromSuperview()
    
  }
}
