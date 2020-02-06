//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/4.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

  static let reuseID = "FavoriteCell"
  let avatarImageView = GFAvatarImageView(frame: .zero)
  let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods

  func set(favorite: Follower) {
    usernameLabel.text = favorite.login
    NetworkManager.shared.downloadImage(from: favorite.avatarUrl) { [weak self] (image) in
      guard let strongSelf = self else { return }
      DispatchQueue.main.async {
        strongSelf.avatarImageView.image = image
      }
    }
  }

  // MARK: Private Methods

  private func configure() {
    addSubViews(avatarImageView, usernameLabel)

    accessoryType = .disclosureIndicator
    let padding: CGFloat = 12

    NSLayoutConstraint.activate([
      avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
      avatarImageView.widthAnchor.constraint(equalToConstant: 60),
      avatarImageView.heightAnchor.constraint(equalToConstant: 60),

      usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
      usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
      usernameLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
}
