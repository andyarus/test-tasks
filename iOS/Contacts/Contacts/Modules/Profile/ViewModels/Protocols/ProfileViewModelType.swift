//
//  ProfileViewModelType.swift
//  Contacts
//
//  Created by Andrei Coder on 02.03.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import RxSwift

protocol ProfileViewModelType {
  var profile: PublishSubject<Void> { get }
  var name: PublishSubject<String> { get }
  var educationPeriod: PublishSubject<String> { get }
  var temperament: PublishSubject<String> { get }
  var phone: PublishSubject<String> { get }
  var biography: PublishSubject<String> { get }
}
