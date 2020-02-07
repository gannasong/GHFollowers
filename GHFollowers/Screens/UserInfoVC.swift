//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/2.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: class {
  func didRequestFollowers(for username: String)
}

class UserInfoVC: UIViewController {

  let scrollView = UIScrollView()
  let contentView = UIView()

  let headView = UIView()
  let itemViewOne = UIView()
  let itemViewTwo = UIView()
  let dateLabel = GFBodyLabel(textAlignment: .center)
  var itemViews: [UIView] = []
  var username: String!
  weak var delegate: UserInfoVCDelegate!
  
  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureScrollView()
    layoutUI()
    getUserInfo()
  }

  // MARK: - Private Methods

  private func configureViewController() {
    view.backgroundColor = .systemBackground
     let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
     navigationItem.rightBarButtonItem = doneButton
  }

  private func configureScrollView() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    scrollView.pinToEdges(of: view)
    contentView.pinToEdges(of: scrollView)

    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.heightAnchor.constraint(equalToConstant: 600)
    ])
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
    add(childVC: GFUserInfoHeaderVC(user: user), to: headView)
    add(childVC: GFRepoItemVC(user: user, delegate: self), to: itemViewOne)
    add(childVC: GFFollowerItemVC(user: user, delegate: self), to: itemViewTwo)
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
      contentView.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
        itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
      ])
    }

    NSLayoutConstraint.activate([
      headView.topAnchor.constraint(equalTo: contentView.topAnchor),
      headView.heightAnchor.constraint(equalToConstant: 210),

      itemViewOne.topAnchor.constraint(equalTo: headView.bottomAnchor, constant: padding),
      itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

      itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
      itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

      dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
      dateLabel.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  private func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }
}

extension UserInfoVC: GFRepoItemVCDelegate {
  func didTapGitHubProfile(for user: User) {
    guard let url = URL(string: user.htmlUrl) else {
      presentGFAlertOnMainThread(title: "Invalid URL",
                                 message: "The url attached to this user is invalid",
                                 buttonTitle: "Ok")
      return
    }

    presentSafariVC(with: url)
  }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
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
