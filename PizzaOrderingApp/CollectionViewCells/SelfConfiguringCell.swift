//
//  SelfConfiguringCell.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import Foundation

protocol SelfConfiguringCell {
  static var reuseIdentifier: String { get }
}
