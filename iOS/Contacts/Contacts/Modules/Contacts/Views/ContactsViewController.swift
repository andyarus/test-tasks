//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Andrei Coder on 18.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit
import Moya

class ContactsViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    testMoya()
  }
  
  private func testMoya() {
    let provider = MoyaProvider<Contacts>()
    provider.rx.request(.getContacts(file: 1)).subscribe { event in
      switch event {
      case .success(let response):
        print("response:\(response)")
      case .error(let error):
        print("Error", error)
      }
    }
  }
  
}
