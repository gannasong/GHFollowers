//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/17.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {

  let tableView = UITableView()
  var favorites: [Follower] = []

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFavorites()
  }

  // MARK: - Private Methods

  private func configureViewController() {
    view.backgroundColor = .systemBackground
    title = "Favorites"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  private func getFavorites() {
    PersistenceManager.retrieveFavorites { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
        case .success(let favorites):
          if favorites.isEmpty {
            strongSelf.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: strongSelf.view)
          } else {
            strongSelf.favorites = favorites
            DispatchQueue.main.async {
              strongSelf.tableView.reloadData()
              strongSelf.view.bringSubviewToFront(strongSelf.tableView)
            }
          }
        case .failure(let error):
          strongSelf.presentGFAlertOnMainThread(title: "Something went wrong",
                                                message: error.rawValue,
                                                buttonTitle: "Ok")
      }
    }
  }

  private func configureTableView() {
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.rowHeight = 80
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
  }
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
    let favorite = favorites[indexPath.row]
    cell.set(favorite: favorite)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let favorite = favorites[indexPath.row]
    let destVC = FollowerListVC(username: favorite.login)
    navigationController?.pushViewController(destVC, animated: true)
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    let favorite = favorites[indexPath.row]
    favorites.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .left)

    PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] (error) in
      guard let strongSelf = self else { return }
      guard let error = error else { return }

      strongSelf.presentGFAlertOnMainThread(title: "Unable to remove",
                                            message: error.rawValue,
                                            buttonTitle: "Ok")
    }
  }
}
