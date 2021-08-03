//
//  ApiHandler.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import Foundation

class ApiHandler {

  typealias CompletionHandler = (Result<[Restaurant], ApiError>) -> Void
  var downloadedRestaurants: [Restaurant] = []

  func loadRestaurants(completionHandler: @escaping CompletionHandler) {
    let url = URL(string: "https://private-anon-94d7d533ab-pizzaapp.apiary-mock.com/restaurants/")!
    var request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
      if let response = response {
        if let data = data, let body = String(data: data, encoding: .utf8) {
        }
      } else {
        print(error ?? "Unknown error")
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
}

enum ApiError: Error {
  case downloadFailed
}
