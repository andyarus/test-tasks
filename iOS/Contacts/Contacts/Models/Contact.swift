//
//  Contact.swift
//  Contacts
//
//  Created by Andrei Coder on 22.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

struct Contact: Decodable {
  let id: String
  let name: String
  let phone: String
  let height: Double
  let biography: String
  let temperament: Temperament
  let educationPeriod: EducationPeriod
}
