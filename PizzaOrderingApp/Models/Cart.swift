//
//  Cart.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-04.
//

import Foundation

struct Cart: Codable {
  var cart: [CartItem] = []
}

struct CartItem: Codable {
  var menuItemId: Int
  var quantity: Int
}
