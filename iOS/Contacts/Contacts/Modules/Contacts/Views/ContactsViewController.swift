//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Andrei Coder on 18.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
  
  // MARK: - Properties
  
  public var viewModel: ContactsViewModel!
  
  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.getContacts()
      .subscribe(onSuccess: { contacts in
        print("contacts:\(contacts.count) \(contacts[0])")
      }, onError: { error in
        print("Error getting contacts", error)
      })
  }
  
}
