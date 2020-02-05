//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/2.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(fontSize: CGFloat) {
    self.init(frame: .zero)
    font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
  }

  // MARK: - Private Methods

  private func configure() {
    textColor = .secondaryLabel
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.90
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }
}
