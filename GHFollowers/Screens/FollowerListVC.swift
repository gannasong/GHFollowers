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
  var hasMoreFollowers = true
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
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
            strongSelf.updateData()
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

  private func updateData() {
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
}
