//
//  OrderState.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-05.
//

import Foundation

struct OrderState: Codable {

  var orderId: Int
  var totalPrice: Int
  var orderedAt: String
  var esitmatedDelivery: String
  var status: String

}
