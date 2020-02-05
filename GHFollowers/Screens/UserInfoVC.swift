//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/2.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: class {
  func didTapGitHubProfile(for user: User)
  func didTapGetFollowers(for user: User)
}

class UserInfoVC: UIViewController {

  let headView = UIView()
  let itemViewOne = UIView()
  let itemViewTwo = UIView()
  let dateLabel = GFBodyLabel(textAlignment: .center)
  var itemViews: [UIView] = []
  var username: String!
  weak var delegate: FollowerListVCDelegate!
  
  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    layoutUI()
    getUserInfo()
  }

  // MARK: - Private Methods

  private func configureViewController() {
    view.backgroundColor = .systemBackground
     let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
     navigationItem.rightBarButtonItem = doneButton
  }

  private func getUserInfo() {
    NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
      guard let strongSelf = self else { return }

      switch result {
        case .success(let user):
          DispatchQueue.main.async {
            strongSelf.configureUIElements(with: user)
          }
        case .failure(let error):
          strongSelf.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }

  private func configureUIElements(with user: User) {
    let repoItemVC = GFRepoItemVC(user: user)
    repoItemVC.delegate = self
    let followerItemVC = GFFollowerItemVC(user: user)
    followerItemVC.delegate = self

    add(childVC: GFUserInfoHeaderVC(user: user), to: headView)
    add(childVC: repoItemVC, to: itemViewOne)
    add(childVC: followerItemVC, to: itemViewTwo)
    dateLabel.text = "GitHub Since \(user.createdAt.convertToMonthYearFormat())"
  }

  @objc private func dismissVC() {
    dismiss(animated: true, completion: nil)
  }

  private func layoutUI() {
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140

    itemViews = [headView, itemViewOne, itemViewTwo, dateLabel]

    for itemView in itemViews {
      view.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
      ])
    }

    NSLayoutConstraint.activate([
      headView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      headView.heightAnchor.constraint(equalToConstant: 180),

      itemViewOne.topAnchor.constraint(equalTo: headView.bottomAnchor, constant: padding),
      itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

      itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
      itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

      dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
      dateLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  private func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }
}

extension UserInfoVC: UserInfoVCDelegate {
  func didTapGitHubProfile(for user: User) {
    guard let url = URL(string: user.htmlUrl) else {
      presentGFAlertOnMainThread(title: "Invalid URL",
                                 message: "The url attached to this user is invalid",
                                 buttonTitle: "Ok")
      return
    }

    presentSafariVC(with: url)
  }

  func didTapGetFollowers(for user: User) {
    guard user.followers != 0 else {
      presentGFAlertOnMainThread(title: "No followers",
                                 message: "This user has no followers. what a shame 😰",
                                 buttonTitle: "So sad")
      return
    }
    delegate.didRequestFollowers(for: user.login)
    dismissVC()
  }
}
