//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/5.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    UITabBar.appearance().tintColor = .systemGreen
    viewControllers = [creatSearchNC(), creatFavoritesNC()]
  }

  // MARK: - Private Methods

  private func creatSearchNC() -> UINavigationController {
    let searchVC = SearchVC()
    searchVC.title = "Srarch"
    searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    return UINavigationController(rootViewController: searchVC)
  }

  private func creatFavoritesNC() -> UINavigationController {
    let favoritesListVC = FavoritesListVC()
    favoritesListVC.title = "Favorites"
    favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    return UINavigationController(rootViewController: favoritesListVC)
  }
}
