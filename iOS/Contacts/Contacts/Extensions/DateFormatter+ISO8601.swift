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
  
  static func string(from educationPeriod: EducationPeriod?) -> String {
    guard let educationPeriod = educationPeriod,
      let startDate = educationPeriod.start,
      let endDate = educationPeriod.end else { return "" }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    
    let startDateString = formatter.string(from: startDate)
    let endDateString = formatter.string(from: endDate)
    return "\(startDateString) - \(endDateString)"
  }
  
}
