//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/1/22.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import Foundation

enum GFError: String, Error {
  case invalidUsername = "This username created an invalid request. Please try again."
  case unableToComplete = "Unable to complete your request. Please check your internet connection"
  case invalidResponse = "Invalid response from the server. Please try again."
  case invalidData = "The data recived from the server was invalid. Please try again."
}
