//
//  EducationPeriod.swift
//  Contacts
//
//  Created by Andrei Coder on 22.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Foundation

import RealmSwift

@objcMembers
class EducationPeriod: Object, Decodable {
  dynamic var start: Date? = nil
  dynamic var end: Date? = nil

  enum CodingKeys: String, CodingKey {
    case start
    case end
  }
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let startDateString = try container.decode(String.self, forKey: .start)
    let endDateString = try container.decode(String.self, forKey: .end)
    guard
      let startDate = DateFormatter.iso8601.date(from: startDateString),
      let endDate = DateFormatter.iso8601.date(from: endDateString)
      else {
      throw DecodingError.dataCorruptedError(forKey: .start,
                                             in: container,
                                             debugDescription: "Incorrect date format")
    }
    
    start = startDate
    end = endDate
  }
  
}
