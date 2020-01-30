//
//  UIHelper.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/31.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

struct UIHelper {
  static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
    let width = view.bounds.width
    let padding: CGFloat = 12
    let minimumItemSpacing: CGFloat = 10
    let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
    let itemWidth = availableWidth / 3

    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

    return flowLayout
  }
}
