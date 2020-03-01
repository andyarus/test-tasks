//
//  ContactsViewModel.swift
//  Contacts
//
//  Created by Andrei Coder on 22.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Moya
import RxSwift

class ContactsViewModel: ContactsViewModelType {
  
  // MARK: Private Properties
  
  private let disposeBag = DisposeBag()
  
  private var _contacts = [Contact]()
  private var contactsFilter = ""
  
  private let lastUpdateTimeKey = "lastUpdateTime"
  private let lastUpdateTimeLimit = 60.0 // Seconds
  private var lastUpdateTime: TimeInterval {
    get {
      let defaults = UserDefaults.standard
      return defaults.double(forKey: lastUpdateTimeKey)
    }
    set {
      let defaults = UserDefaults.standard
      defaults.setValue(newValue, forKey: lastUpdateTimeKey)
    }
  }
  
  private var isContactsLoading = false
  
  // MARK: Service Properties
  
  private let networkService: NetworkService!
  private let databaseService: DatabaseService!
  
  // MARK: Public Properties
  
  public let getContacts = PublishSubject<Bool>()
  public let getFilteredContacts = PublishSubject<String>()
  public let contacts = PublishSubject<[Contact]>()
  public let error = PublishSubject<Error>()
  
  // MAKR: - Init
  
  init(provider: MoyaProvider<Contacts>) {
    networkService = NetworkService(provider: provider)
    databaseService = DatabaseService()
    
    setupRx()
  }
  
  // MARK: - Setup Rx
  
  private func setupRx() {
    /// Input
    getContacts
      .subscribe(onNext: { [unowned self] must in
        guard must else { return }
        self._getContacts()
      }).disposed(by: disposeBag)
    
    /// Filter
    getFilteredContacts
      .subscribe(onNext: { [unowned self] filter in
        self.contactsFilter = filter
        self._getContacts(with: filter)
      }).disposed(by: disposeBag)
  }
  
  // MARK: Private Methods
  
  /// Get contacts from data source
  private func _getContacts() {
    /// Don't start new loading while previous not done yet
    guard !isContactsLoading else { return }
    
    /// Load contacts from local storage if update time limit not exceeded
    if useLocalStorage() {
      _contacts = databaseService.read()
      contacts.onNext(_contacts)
      return
    }
    
    /// Load contacts from network
    isContactsLoading = true
    Observable
      .merge(contactsSources())
      .reduce([], accumulator: +)
      .materialize()
      .share()
      .subscribe(onNext: { [unowned self] event in
        switch event {
        case .next(let contacts):
          //self._contacts = Array(Set(contacts)) /// Remove duplicates
          self._contacts = contacts.sorted { $0.name < $1.name }
          
          /// If filtering now
          guard self.contactsFilter.isEmpty else {
            self._getContacts(with: self.contactsFilter)
            return
          }
          
          self.contacts.onNext(self._contacts)
          
          /// Save contacts to local storage
          self.saveContacts(self._contacts)
        case .error(let error):
          print("error", error)
          self.error.onNext(error)
        default:
          break
        }
        self.isContactsLoading = false
      }).disposed(by: disposeBag)
  }
  
  /// Get filtered contacts
  private func _getContacts(with filter: String) {
    let contacts = self._contacts.filter {
      guard !filter.isEmpty else { return true }
      if filter.isPhone() {
        return $0.phone.contains(filter.clearPhone())
      }
      return $0.name.lowercased().contains(filter.lowercased())
    }
    self.contacts.onNext(contacts)
  }
  
  private func contactsSources() -> [Observable<[Contact]>] {
    return
      [
        networkService.fetchContacts(forSource: 1),
        networkService.fetchContacts(forSource: 2),
        networkService.fetchContacts(forSource: 3)
      ]
  }
  
  private func saveContacts(_ contacts: [Contact]) {
    //DispatchQueue.main.async {
    databaseService.update(with: contacts)
    //self.databaseService.update(with: contacts, qos: .background)
    lastUpdateTime = Date().timeIntervalSince1970
    //}
  }
  
}

// MARK: - Helpers

extension ContactsViewModel {
  
  private func useLocalStorage() -> Bool {
    let currentTime = Date().timeIntervalSince1970
    let leftTime = currentTime - lastUpdateTime
    if leftTime < lastUpdateTimeLimit {
      return true
    }
    return false
  }
  
}
