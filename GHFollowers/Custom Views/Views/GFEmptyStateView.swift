//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/2.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {

  let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
  let logoImageVeiw = UIImageView()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  init(message: String) {
    super.init(frame: .zero)
    messageLabel.text = message
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func configure() {
    addSubview(messageLabel)
    addSubview(logoImageVeiw)

    logoImageVeiw.translatesAutoresizingMaskIntoConstraints = false

    messageLabel.numberOfLines = 3
    messageLabel.textColor = .secondaryLabel

    logoImageVeiw.image = UIImage(named: "empty-state-logo")

    NSLayoutConstraint.activate([
      messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
      messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
      messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
      messageLabel.heightAnchor.constraint(equalToConstant: 200)
    ])

    NSLayoutConstraint.activate([
      logoImageVeiw.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1.3),
      logoImageVeiw.heightAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1.3),
      logoImageVeiw.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
      logoImageVeiw.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
    ])
  }
}
