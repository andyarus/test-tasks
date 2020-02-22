//
//  String+CapitalizingFirstLetter.swift
//  Contacts
//
//  Created by Andrei Coder on 23.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

extension String {
  
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }

  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
  
}
