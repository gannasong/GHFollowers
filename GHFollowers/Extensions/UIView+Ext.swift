//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/7.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

extension UIView {

  func addSubViews(_ views: UIView...) {
    for view in views {
      addSubview(view)
    }
  }
}
