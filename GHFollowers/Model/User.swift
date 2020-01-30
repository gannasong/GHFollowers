//
//  User.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/19.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import Foundation

struct User: Codable {
  var login: String
  var avatarUrl: String
  var name: String?
  var localtion: String?
  var bio: String?
  var publicRepos: Int
  var publicGists: Int
  var htmlUrl: String
  var following: Int
  var followers: Int
  var createdAt: String
}
