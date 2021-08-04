//
//  ApiHandler.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import Foundation

class ApiHandler {

  typealias RestaurantHandler = (Result<[Restaurant], ApiError>) -> Void
  typealias MenuHandler = (Result<[MenuItem], ApiError>) -> Void
  var downloadedRestaurants: [Restaurant] = []
  var downloadedMenuItems: [MenuItem] = []

  func loadRestaurants(completionHandler: @escaping RestaurantHandler) {
    let url = URL(string: "https://private-anon-94d7d533ab-pizzaapp.apiary-mock.com/restaurants/")!
    var request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
      if let response = response {
        if let data = data, let body = String(data: data, encoding: .utf8) {
        }
      } else {
        print(error ?? "Error downloading restaurants")
        completionHandler(.failure(ApiError.downloadFailed))
      }
      let response = try! JSONDecoder().decode([Restaurant].self, from: data!)
      for pizzaPlace in response {
        print(pizzaPlace.name)
        self.downloadedRestaurants.append(pizzaPlace)
      }
      completionHandler(.success(self.downloadedRestaurants))
    }
    task.resume()
  }

  func loadMenu(id: Int, completionHandler: @escaping MenuHandler) {

    let url = URL(string: "https://private-anon-94d7d533ab-pizzaapp.apiary-mock.com/restaurants/\(id)/menu")!
    var request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let response = response {
        if let data = data, let body = String(data: data, encoding: .utf8) {
        }
      } else {
        print(error ?? "Error downloading menu")
        completionHandler(.failure(ApiError.downloadFailed))
      }

      let response = try! JSONDecoder().decode([MenuItem].self, from: data!)
      for item in response {
        print(item.name)
        self.downloadedMenuItems.append(item)
      }
      completionHandler(.success(self.downloadedMenuItems))
    }
    task.resume()
  }
}

enum ApiError: Error {
  case downloadFailed
}
