//
//  Restaurant.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import Foundation
import CoreLocation

struct Restaurant: Codable, Hashable {

  var id: Int
  var name: String
  var address1: String
  var address2: String
  var latitude: Double
  var longitude: Double

  func distance(to location: CLLocation) -> CLLocationDistance {
    return location.distance(from: CLLocation(latitude: self.latitude, longitude: self.longitude))
      }
}
