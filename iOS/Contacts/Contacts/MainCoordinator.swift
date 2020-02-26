//
//  MainCoordinator.swift
//  Contacts
//
//  Created by Andrei Coder on 27.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
  
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let vc = ContactsViewController()
    vc.coordinator = self
    vc.viewModel = ContactsViewModel()
    navigationController.pushViewController(vc, animated: false)
  }
  
  func openProfile(for contact: Contact) {
    let vc = ProfileViewController(contact: contact)
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: true)
  }
  
}
