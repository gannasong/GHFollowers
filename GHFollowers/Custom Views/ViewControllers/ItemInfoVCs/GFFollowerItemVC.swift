//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/3.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

protocol GFFollowerItemVCDelegate: class {
  func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {

  weak var delegate: GFFollowerItemVCDelegate!

  // MARK: - Initialization

  init(user: User, delegate: GFFollowerItemVCDelegate) {
    super.init(user: user)
    self.delegate = delegate
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }

  // MARK: - Private Methods

  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
    itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
    actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
  }

  override func actionButtonTapped() {
    delegate.didTapGetFollowers(for: user)
  }
}
