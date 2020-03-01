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
  
  private let disposeBag = DisposeBag()
  
  private var _contacts = [Contact]()
  
  private let lastUpdateTimeKey = "lastUpdateTime"
  private let lastUpdateTimeLimit = 1.0 // Seconds
  private var lastUpdateTime: TimeInterval {
    get {
      let defaults = UserDefaults.standard
      return defaults.double(forKey: lastUpdateTimeKey)
    }
    set {
      let defaults = UserDefaults.standard
      defaults.setValue(newValue, forKey: lastUpdateTimeKey)
      defaults.synchronize()
    }
  }
  
  private var isContactsLoading = false
  
  // MARK: Service Properties
  
  private let networkService: NetworkService!
  private let databaseService: DatabaseService!
  
  // MARK: Public Properties
  
  public let getContacts = PublishSubject<Bool>()
  public let filterContacts = PublishSubject<String>()
  public let contacts = PublishSubject<[Contact]>()
  public let error = PublishSubject<Error>()
  
  // MAKR: - Init
  
  init(provider: MoyaProvider<Contacts>) {
    networkService = NetworkService(provider: provider)
    databaseService = DatabaseService()
    
    setupRx()
  }
  
  private func setupRx() {
    /// Input
    getContacts
      .subscribe(onNext: { [unowned self] must in
        print("getContacts next must:", must)
        guard must else { return }
        self._getContacts()
      }).disposed(by: disposeBag)
    
    /// Filter
    filterContacts
      .subscribe(onNext: { [unowned self] filter in
        print("filterContacts next filter:", filter)
        guard !filter.isEmpty else { return }
        self._getContacts(with: filter)
      }).disposed(by: disposeBag)
    
    /// Save contacts to Realm
    contacts
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] contacts in
        print("ContactsViewModel contacts:", contacts.count)
        
        //self.databaseService.update(with: contacts)
        //self.databaseService.update(with: contacts)
        
      }).disposed(by: disposeBag)
  }
  
  
  
//  public func contact(at pos: Int) -> Contact? {
//    guard pos < _contacts.count else { return nil }
//    return _contacts[pos]
//  }
  
  
  
  // MARK: Private Methods
  
  /// Get contacts from data source
  private func _getContacts() {
    
    print("getContacts thread:\(Thread.current)")
    
    /// Don't start new loading while previous not done yet
    guard !isContactsLoading else { return }
    
   // let test = databaseService.read()
    //print("_contacts realm:", test.count)
//    //self.contacts.onNext(contacts)
//    return
    
    
    
    
    isContactsLoading = true
    
    Observable
      .merge(contactsSources())
      .reduce([], accumulator: +)
      .materialize()
      .share()
      .subscribe(onNext: { [unowned self] event in
        switch event {
        case .next(let contacts):
          print("next contacts.count:", contacts.count, "contactsUnique:", Set(contacts).count)
          self._contacts = contacts
          self.contacts.onNext(contacts)
        case .error(let error):
          print("event error", error)
          self.error.onNext(error)
        default:
          //case .completed:
          print("default completed")
          break
        }
        self.isContactsLoading = false
      }).disposed(by: disposeBag)
  }
  
  /// Get filtered contacts
  private func _getContacts(with filter: String) {
    let contacts = self._contacts.filter {
      if filter.isPhone() {
        return $0.phone.contains(filter.clearPhone())
      }
      return $0.name.lowercased().hasPrefix(filter)
    }
    self.contacts.onNext(contacts)
  }
  
  private func setContacts() {
    
  }
  
  
  // MARK: Private Methods
  
  private func contactsSources() -> [Observable<[Contact]>] {
    return
      [
        networkService.fetchContacts(forSource: 1),
        networkService.fetchContacts(forSource: 2),
        networkService.fetchContacts(forSource: 3)
      ]
  }
  
}

// MARK: - Helpers

extension ContactsViewModel {
  
  private func useLocalStorage() -> Bool {
    let currentTime = Date().timeIntervalSince1970
    let leftTime = currentTime - self.lastUpdateTime
    if leftTime < lastUpdateTimeLimit {
      return true
    }
    return false
  }
  
}
