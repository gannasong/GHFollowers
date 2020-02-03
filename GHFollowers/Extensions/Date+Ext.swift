//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by SUNG HAO LIN on 2020/2/4.
//  Copyright © 2020 SUNG HAO LIN. All rights reserved.
//

import Foundation

extension Date {

  func convertToMonthYearFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM yyyy"
    return dateFormatter.string(from: self)
  }
}
