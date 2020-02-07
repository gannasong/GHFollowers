//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/30.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

  private let placeholderImage = Images.placeholder
  let cache = NetworkManager.shared.cache

  // MARK: - Initializstion

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods

  func downloadImage(fromURL url: String) {
    NetworkManager.shared.downloadImage(from: url) { [weak self] (image) in
      guard let strongSelf = self else { return }
      DispatchQueue.main.async {
        strongSelf.image = image
      }
    }
  }

  // MARK: - Private Methods

  private func configure() {
    layer.cornerRadius = 10
    clipsToBounds = true
    image = placeholderImage
    translatesAutoresizingMaskIntoConstraints = false
  }
}
