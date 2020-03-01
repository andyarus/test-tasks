//
//  NetworkServiceType.swift
//  Contacts
//
//  Created by Andrei Coder on 02.03.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Moya
import RxSwift

protocol NetworkServiceType {
  var provider: MoyaProvider<Contacts> { get }
  func fetchContacts(forSource source: Int) -> Observable<[Contact]>
}
