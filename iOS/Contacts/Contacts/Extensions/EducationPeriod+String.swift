//
//  EducationPeriod+String.swift
//  Contacts
//
//  Created by Andrei Coder on 24.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

extension EducationPeriod {
  
  func toString() -> String {
    guard let startDate = self.start,
      let endDate = self.end else { return "" }
    let startDateString = Utils.dateFormatter.string(from: startDate)
    let endDateString = Utils.dateFormatter.string(from: endDate)
    return "\(startDateString) - \(endDateString)"
  }
  
}
