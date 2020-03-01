//
//  NetworkService.swift
//  Contacts
//
//  Created by Andrei Coder on 01.03.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Moya
import RxSwift

class NetworkService: NetworkServiceType {
  
  let provider: MoyaProvider<Contacts>
  
  init(provider: MoyaProvider<Contacts>) {
    self.provider = provider
  }
  
  func fetchContacts(forSource source: Int) -> Observable<[Contact]> {
    return provider.rx.request(.contacts(source: source))
      .filterSuccessfulStatusCodes()
      .map([Contact].self)
      .asObservable()
  }
  
}
