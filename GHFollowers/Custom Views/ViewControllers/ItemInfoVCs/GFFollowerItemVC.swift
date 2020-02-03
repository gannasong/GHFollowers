//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/3.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {

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
