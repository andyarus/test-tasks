//
//  ContactsViewModelType.swift
//  Contacts
//
//  Created by Andrei Coder on 02.03.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import RxSwift

protocol ContactsViewModelType {
  var getContacts: PublishSubject<Bool> { get }
  var getFilteredContacts: PublishSubject<String> { get }
  var contacts: PublishSubject<[Contact]> { get }
  var error: PublishSubject<Error> { get }
}
