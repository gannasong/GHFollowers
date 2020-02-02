//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/18.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {

  enum Section {
    case main
  }

  var username: String!
  var page: Int = 1
  var followers: [Follower] = []
  var filterFollowers: [Follower] = []
  var hasMoreFollowers = true
  var isSearching = false
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureSearchController()
    configureCollectionView()
    getFollowers(username: username, page: page)
    configureDataSource()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

  // MARK: - Private Methods

  private func configureViewController() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  private func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
  }

  private func configureSearchController() {
    let searchController = UISearchController()
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.searchBar.placeholder = "Search for a username"
    searchController.obscuresBackgroundDuringPresentation = false // false -> 取消背景模糊狀態
    navigationItem.searchController = searchController
  }

  private func getFollowers(username: String, page: Int) {
    showLoadingView()

    NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] (result) in
      guard let strongSelf = self else { return }

      strongSelf.dismissLoadingView()
      switch result {
        case .success(let followers):
          if followers.count < 100 {
            strongSelf.hasMoreFollowers = false
          }
          strongSelf.followers.append(contentsOf: followers)

          if strongSelf.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😏."
            DispatchQueue.main.async {
              strongSelf.showEmptyStateView(with: message, in: strongSelf.view)
            }
          } else {
            strongSelf.updateData(on: strongSelf.followers)
          }
        case .failure(let error):
          strongSelf.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }

  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell else {
        return UICollectionViewCell()
      }
      cell.set(follower: follower)
      return cell
    })
  }

  private func updateData(on followers: [Follower]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
    snapshot.appendSections([.main])
    snapshot.appendItems(followers)
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
  }
}

extension FollowerListVC: UICollectionViewDelegate {

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.size.height

    print("offsetY: \(offsetY)") // 左上角的位置
    print("contentHeight: \(contentHeight)") // 整個 scrollview 的總高度
    print("height: \(height)") // 裝置螢幕高度

    // 這邊表示畫面左上角的位置已經超過一個螢幕的高度
    if offsetY > contentHeight - height {
      guard hasMoreFollowers else { return }
      page += 1
      getFollowers(username: username, page: page)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let activeArray = isSearching ? filterFollowers : followers
    let follower = activeArray[indexPath.item]
    let destVC = UserInfoVC()
    destVC.username = follower.login
    let navController = UINavigationController(rootViewController: destVC)
    present(navController, animated: true, completion: nil)
  }
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {

  func updateSearchResults(for searchController: UISearchController) {
    guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
    isSearching = true
    filterFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
    updateData(on: filterFollowers)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
    updateData(on: followers)
  }
}
