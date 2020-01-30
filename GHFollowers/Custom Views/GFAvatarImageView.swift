//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/30.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

  private let placeholderImage = UIImage(named: "avatar-placeholder")

  // MARK: - Initializstion

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func configure() {
    layer.cornerRadius = 10
    clipsToBounds = true
    image = placeholderImage
    translatesAutoresizingMaskIntoConstraints = false
  }
}
