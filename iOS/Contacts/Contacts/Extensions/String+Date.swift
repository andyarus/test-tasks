//
//  String+Date.swift
//  Contacts
//
//  Created by Andrei Coder on 24.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Foundation

extension String {
  
  func toDate() -> Date? {
    return Utils.iso8601DateFormatter.date(from: self)
  }
  
}
