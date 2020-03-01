//
//  DatabaseServiceType.swift
//  Contacts
//
//  Created by Andrei Coder on 02.03.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Foundation

protocol DatabaseServiceType {
  func create(with contacts: [Contact])
  func read() -> [Contact]
  func update(with contacts: [Contact])
  func update(with contacts: [Contact], qos: DispatchQoS.QoSClass, reduceMemoryUsage: Bool)
  func delete()
}
