//
//  MenuItem.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import Foundation

struct MenuItem: Codable, Hashable {
  
  var id: Int
  var category: String
  var name: String
  var topping: [String]?
  var price: Int
  var rank: Int?

}


