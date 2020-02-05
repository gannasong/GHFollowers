//
//  GFAlertContainerView.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/5.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class GFAlertContainerView: UIView {

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    cinfigure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func cinfigure() {
    backgroundColor = .systemBackground
    layer.cornerRadius = 14
    layer.borderWidth = 2
    layer.borderColor = UIColor.white.cgColor
    translatesAutoresizingMaskIntoConstraints = false
  }
}
