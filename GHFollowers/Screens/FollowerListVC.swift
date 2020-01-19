//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/18.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {

  var username: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.prefersLargeTitles = true
  }

}
