//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/30.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class FollowerCell: UICollectionViewCell {

  static let reuseID = "FollowerCell"
  let avatarImageView = GFAvatarImageView(frame: .zero)
  let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods

  func set(follower: Follower) {
    avatarImageView.downloadImage(fromURL: follower.avatarUrl)
    usernameLabel.text = follower.login
  }

  // MARK: - Private Methods

  private func configure() {
    addSubViews(avatarImageView, usernameLabel)
    let padding: CGFloat = 8

    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
    ])

    NSLayoutConstraint.activate([
      usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
      usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      usernameLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
}
