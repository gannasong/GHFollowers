//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/2.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {

  let headView = UIView()

  var username: String!

  // MARK: - Initialization

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = doneButton
    layoutUI()

    NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
      guard let strongSelf = self else { return }

      switch result {
        case .success(let user):
          DispatchQueue.main.async {
            strongSelf.add(childVC: GFUserInfoHeaderVC(user: user), to: strongSelf.headView)
          }
        case .failure(let error):
          strongSelf.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }

  // MARK: - Private Methods

  @objc private func dismissVC() {
    dismiss(animated: true, completion: nil)
  }

  private func layoutUI() {
    view.addSubview(headView)
    headView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      headView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      headView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      headView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      headView.heightAnchor.constraint(equalToConstant: 180)
    ])
  }

  private func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }
}
