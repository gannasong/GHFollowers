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

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(message: String) {
    self.init(frame: .zero)
    messageLabel.text = message
  }

  // MARK: - Private Methods

  private func configure() {
    addSubViews(messageLabel, logoImageVeiw)
    configureLogoImageView()
    configureMessageLabel()
  }

  private func configureLogoImageView() {
    logoImageVeiw.translatesAutoresizingMaskIntoConstraints = false
    logoImageVeiw.image = Images.emptyStateLogo

    let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
    let logoImageViewBottomConstraint = logoImageVeiw.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomConstant)
    logoImageViewBottomConstraint.isActive = true

    NSLayoutConstraint.activate([
      logoImageVeiw.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1.3),
      logoImageVeiw.heightAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1.3),
      logoImageVeiw.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170)
    ])
  }

  private func configureMessageLabel() {
    messageLabel.numberOfLines = 3
    messageLabel.textColor = .secondaryLabel

    let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
    let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant)
    messageLabelCenterYConstraint.isActive = true

    NSLayoutConstraint.activate([
      messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
      messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
      messageLabel.heightAnchor.constraint(equalToConstant: 200)
    ])
  }
}
