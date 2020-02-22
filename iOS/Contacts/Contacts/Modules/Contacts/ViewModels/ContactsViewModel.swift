//
//  ContactsViewModel.swift
//  Contacts
//
//  Created by Andrei Coder on 22.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Moya
import RxSwift

class ContactsViewModel {
  
  // MARK: Private Properties
  
  let provider = MoyaProvider<Contacts>()
  //let provider = MoyaProvider<Contacts>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
  
  // MARK: Public Methods
  
  public func getContacts() -> Single<[Contact]> {
    return provider.rx.request(.contacts(file: 1))
      .filterSuccessfulStatusCodes()
      .map([Contact].self)
  }
  
}
