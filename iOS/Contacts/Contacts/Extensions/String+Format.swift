//
//  String+Format.swift
//  Contacts
//
//  Created by Andrei Coder on 24.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

extension String {
  
  @discardableResult
  mutating func formatPhone() -> String {
    self = replacingOccurrences(of: "(", with: "")
    self = replacingOccurrences(of: ")", with: "")
    self = replacingOccurrences(of: "-", with: "")
    
    [10, 13].forEach { offsetBy in
      if self.count >= offsetBy {
        self.insert("-", at: index(startIndex, offsetBy: offsetBy))
      }
    }
    
    return self
  }
  
}
