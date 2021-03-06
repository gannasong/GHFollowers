//
//  GFItemInfoVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/3.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

protocol ItemInfoVCDelegate: class {
  func didTapGitHubProfile(for user: User)
  func didTapGetFollowers(for user: User)
}

class GFItemInfoVC: UIViewController {

  let stackView = UIStackView()
  let itemInfoViewOne = GFItemInfoView()
  let itemInfoViewTwo = GFItemInfoView()
  let actionButton = GFButton()
  var user: User!

  // MARK: - Initialization

  init(user: User) {
    super.init(nibName: nil, bundle: nil)
    self.user = user
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackgroundView()
    configureActionButton()
    layoutUI()
    configureStackView()
  }

  // MARK: - Public Methods

  @objc func actionButtonTapped() {}

  // MARK: - Private Methods

  private func configureStackView() {
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    stackView.addArrangedSubview(itemInfoViewOne)
    stackView.addArrangedSubview(itemInfoViewTwo)
  }

  private func configureBackgroundView() {
    view.layer.cornerRadius = 18
    view.backgroundColor = .secondarySystemBackground
  }

  private func configureActionButton() {
    actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
  }

  private func layoutUI() {
    view.addSubViews(stackView, actionButton)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    let padding: CGFloat = 20

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      stackView.heightAnchor.constraint(equalToConstant: 50),

      actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
      actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      actionButton.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
}
