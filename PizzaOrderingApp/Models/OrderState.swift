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

  func formatDate(getDate: String) -> String {

    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    var result = formatter.date(from: getDate)
    print("DATE")
    print(result)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM - HH:mm"
    let readableDate = dateFormatter.string(from: result!)

    return readableDate
  }
}
