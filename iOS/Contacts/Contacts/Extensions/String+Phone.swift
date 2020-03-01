//
//  String+Phone.swift
//  Contacts
//
//  Created by Andrei Coder on 02.03.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Foundation

extension String {
  
  func formatPhone() -> String {
    var result = self
    
    [2, 6].forEach { offsetBy in
      if result.count >= offsetBy {
        result.insert(" ", at: result.index(result.startIndex, offsetBy: offsetBy))
      }
    }
    [10, 13].forEach { offsetBy in
      if result.count >= offsetBy {
        result.insert("-", at: result.index(result.startIndex, offsetBy: offsetBy))
      }
    }
    
    return result
  }
  
  func isPhone() -> Bool {
    let phoneRegex = "\\+?[0-9\\s\\-]+"
    let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return predicate.evaluate(with: self)
  }
  
  func clearPhone() -> String {
    var result = self
    result = result.replacingOccurrences(of: "(", with: "")
    result = result.replacingOccurrences(of: ")", with: "")
    result = result.replacingOccurrences(of: "-", with: "")
    result = result.replacingOccurrences(of: " ", with: "")
    
    return result
  }
  
}
