//
//  DateFormatter+ISO8601.swift
//  Contacts
//
//  Created by Andrei Coder on 22.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Foundation

extension DateFormatter {
  
  static let iso8601 = ISO8601DateFormatter()
  
  static func string(from educationPeriod: EducationPeriod) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    
    let startDateString = formatter.string(from: educationPeriod.start)
    let endDateString = formatter.string(from: educationPeriod.end)
    return "\(startDateString) - \(endDateString)"
  }
  
}
