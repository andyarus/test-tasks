//
//  Utils.swift
//  Contacts
//
//  Created by Andrei Coder on 24.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Foundation

class Utils {
  
  // MARK: - Static Properties
  
  static let iso8601DateFormatter = ISO8601DateFormatter()
  
  static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter
  }()
  
}
