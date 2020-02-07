//
//  GFButton.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/17.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFButton: UIButton {

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(backgroundColor: UIColor, title: String) {
    self.init(frame: .zero)
    self.backgroundColor = backgroundColor
    self.setTitle(title, for: .normal)
  }

  // MARK: - Public Methods

  func set(backgroundColor: UIColor, title: String) {
    self.backgroundColor = backgroundColor
    setTitle(title, for: .normal)
  }

  // MARK: - Private Methods

  private func configure() {
    layer.cornerRadius = 10
    titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    setTitleColor(.white, for: .normal)
    translatesAutoresizingMaskIntoConstraints = false
  }
}
