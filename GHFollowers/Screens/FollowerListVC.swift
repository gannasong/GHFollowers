//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/18.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

protocol FollowerListVCDelegate: class {
  func didRequestFollowers(for username: String)
}

class FollowerListVC: GFDataLoadingVC {

  enum Section {
    case main
  }

  var username: String!
  var page: Int = 1
  var followers: [Follower] = []
  var filterFollowers: [Follower] = []
  var hasMoreFollowers = true
  var isSearching = false
  var isLoadingMoreFollowers = false
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

  // MARK: - Initialization

  init(username: String) {
    super.init(nibName: nil, bundle: nil)
    self.username = username
    title = username
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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

    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    navigationItem.rightBarButtonItem = addButton
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

  @objc private func addButtonTapped() {
    showLoadingView()
    isLoadingMoreFollowers == true
    NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
      guard let strongSelf = self else { return }
      strongSelf.dismissLoadingView()

      switch result {
        case .success(let user):
          let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
          PersistenceManager.updateWith(favorite: favorite, actionType: .add) { (error) in
            guard let error = error else {
              strongSelf.presentGFAlertOnMainThread(title: "Success!",
                                                    message: "You have successfully favorited this user 🎉",
                                                    buttonTitle: "Hooray!")
              return
            }

            strongSelf.presentGFAlertOnMainThread(title: "Something went wrong",
                                                  message: error.rawValue,
                                                  buttonTitle: "Ok")
          }
        case .failure(let error):
          strongSelf.presentGFAlertOnMainThread(title: "Something went wrong",
                                                message: error.rawValue,
                                                buttonTitle: "Ok")
      }
      strongSelf.isLoadingMoreFollowers = false
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
      guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
      page += 1
      getFollowers(username: username, page: page)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let activeArray = isSearching ? filterFollowers : followers
    let follower = activeArray[indexPath.item]
    let destVC = UserInfoVC()
    destVC.delegate = self
    destVC.username = follower.login
    let navController = UINavigationController(rootViewController: destVC)
    present(navController, animated: true, completion: nil)
  }
}

extension FollowerListVC: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    guard let filter = searchController.searchBar.text, !filter.isEmpty else {
      filterFollowers.removeAll()
      updateData(on: followers)
      isSearching = false
      return
    }

    isSearching = true
    filterFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
    updateData(on: filterFollowers)
  }
}

extension FollowerListVC: FollowerListVCDelegate {

  func didRequestFollowers(for username: String) {
    self.username = username
    title = username
    page = 1
    followers.removeAll()
    filterFollowers.removeAll()
    collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    getFollowers(username: username, page: page)
  }
}
