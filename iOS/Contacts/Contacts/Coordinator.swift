//
//  Coordinator.swift
//  Contacts
//
//  Created by Andrei Coder on 27.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  func start()
}
