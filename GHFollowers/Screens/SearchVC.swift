//
//  SearchVC.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/17.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

  let logoImageView = UIImageView()
  let usernameTextField = GFTextField()
  let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

  var isUsernameEntered: Bool {
    return !usernameTextField.text!.isEmpty
  }

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubViews(logoImageView, usernameTextField, callToActionButton)
    configureLogoImageView()
    configureTextField()
    configureCallToActionButton()
    createDismissKeyboardTapGesture()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    usernameTextField.text = ""
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  // MARK: - Private Methods

  private func createDismissKeyboardTapGesture(){
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
    view.addGestureRecognizer(tap)
  }

  @objc private func pushFollowerListVC() {
    guard isUsernameEntered else {
      presentGFAlertOnMainThread(title: "Empty Username",
                                 message: "Please enter a username. We need to know who to look for 😜.",
                                 buttonTitle: "Ok")
      return
    }

    usernameTextField.resignFirstResponder()

    let followerListVC = FollowerListVC(username: usernameTextField.text!)
    navigationController?.pushViewController(followerListVC, animated: true)
  }

  private func configureLogoImageView() {
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.image = Images.ghLogo

    let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80

    NSLayoutConstraint.activate([
      logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.heightAnchor.constraint(equalToConstant: 200),
      logoImageView.widthAnchor.constraint(equalToConstant: 200)
    ])
  }

  private func configureTextField() {
    usernameTextField.delegate = self

    NSLayoutConstraint.activate([
      usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
      usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      usernameTextField.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  private func configureCallToActionButton() {
    callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)

    NSLayoutConstraint.activate([
      callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
      callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      callToActionButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
}

extension SearchVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    pushFollowerListVC()
    return true
  }
}
