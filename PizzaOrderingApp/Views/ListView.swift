//
//  ListView.swift
//  PizzaOrderingApp
//
//  Created by Pontus Croneld on 2021-08-03.
//

import UIKit

class ListView: UIViewController {

  var apiHandler: ApiHandler?
  var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

      apiHandler = ApiHandler()
      view.backgroundColor = .systemRed
        // Do any additional setup after loading the view.
    }
}

