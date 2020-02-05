//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/19.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFTitleLabel: UILabel {

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
    self.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold)
  }

  // MARK: - Private Methods

  private func configure() {
    textColor = .label
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.9
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }
}
