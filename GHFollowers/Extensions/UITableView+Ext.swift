//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/7.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

extension UITableView {

  func removeExcessCells() {
    tableFooterView = UIView(frame: .zero)
  }

  func reloadDataOnMainThread() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }
}
