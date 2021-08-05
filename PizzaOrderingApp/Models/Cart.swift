//
//  Cart.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-04.
//

import Foundation

struct ReadableCartItem {
  var name: String
  var quantity: Int
}

struct CartItem: Codable {
  var menuItemId: Int
  var quantity: Int
}
