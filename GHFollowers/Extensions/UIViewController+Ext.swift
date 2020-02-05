//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/19.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {

  func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
    DispatchQueue.main.async {
      let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
      alertVC.modalPresentationStyle = .overFullScreen
      alertVC.modalTransitionStyle = .crossDissolve
      self.present(alertVC, animated: true, completion: nil)
    }
  }

  func presentSafariVC(with url: URL) {
    let safariVC = SFSafariViewController(url: url)
    safariVC.preferredControlTintColor = .systemGreen
    present(safariVC, animated: true, completion: nil)
  }
}
