//
//  ProfileViewModel.swift
//  Contacts
//
//  Created by Andrei Coder on 02.03.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import RxSwift

class ProfileViewModel: ProfileViewModelType {
  
  // MARK: - Public Properties
  
  /// Input
  public let profile = PublishSubject<Void>()
  /// Output
  public let name = PublishSubject<String>()
  public let educationPeriod = PublishSubject<String>()
  public let temperament = PublishSubject<String>()
  public let phone = PublishSubject<String>()
  public let biography = PublishSubject<String>()
  
  // MARK: - Private Properties
  
  private let contact: Contact!
  private let disposeBag = DisposeBag()
  
  // MARK: - Init
  
  init(contact: Contact) {
    self.contact = contact
    
    setupRx()
  }
  
  // MARK: - Setup Rx
  
  private func setupRx() {
    /// Input
    profile
      .subscribe(onNext: { [unowned self] in
        self.setProfile()
      }).disposed(by: disposeBag)
  }
  
  // MARK: - Private Methods
  
  private func setProfile() {
    name.onNext(contact.name)
    educationPeriod.onNext(contact.educationPeriod?.toString() ?? "")
    temperament.onNext(contact.temperament.value())
    phone.onNext(contact.phone.formatPhone())
    biography.onNext(contact.biography)
  }
  
}
