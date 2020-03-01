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
  public let contacts = PublishSubject<[Contact]>()
  public let error = PublishSubject<Error>()
  
  // MAKR: - Init
  
  init(provider: MoyaProvider<Contacts>) {
    networkService = NetworkService(provider: provider)
    databaseService = DatabaseService()
    
    /// Input
    getContacts
      .subscribe(onNext: { [unowned self] must in
        print("getContacts next must:", must)
        guard must else { return }
        self._getContacts()
      }).disposed(by: disposeBag)
  }
  
  // MARK: Public Methods
  
  private func _getContacts() {
    
    print("getContacts thread:\(Thread.current)")
    
    /// Don't start new loading while previous not done yet
    guard !isContactsLoading else { return }
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
  
  public func loadData(with filter: String) {
    //DispatchQueue.main.async { [unowned self] in
      let matchingСontacts = self._contacts.filter { $0.name.hasPrefix(filter) }
      self.contacts.onNext(matchingСontacts)
    //}
  }
  
  public func contact(at pos: Int) -> Contact? {
    guard pos < _contacts.count else { return nil }
    return _contacts[pos]
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
  
//  private func getMergedPages(forMax max: Int) -> Observable<[Contact]> {
//    var pagesObservable = [Observable<[Contact]>]()
//    for i in 1...max {
//      pagesObservable.append(getNext(for: i))
//    }
//
////    for i in 1...50 {
////      var page = i % 3
////      if page == 0 {
////        page = 1
////      }
////      pagesObservable.append(getNext(for: page))
////    }
//
//    let pagesSequence = Observable.from(pagesObservable)
//    return pagesSequence.merge()
//  }
  
//  private func getNext(for page: Int) -> Observable<[Contact]> {
//
//    //callbackQueue
//    //Callback queue. If nil - queue from provider initializer will be used.
//    //return provider.rx.request(.contacts(page: page), callbackQueue: DispatchQueue.main)
//
//    return provider.rx.request(.contacts(source: page))
//      .filterSuccessfulStatusCodes()
//      .map([Contact].self)
//      .asObservable()
//  }
  
  private func sources(max: Int) -> [Observable<[Contact]>] {
    var result = [Observable<[Contact]>]()
    for i in 1...max {
      result.append(networkService.fetchContacts(forSource: i))
      //result.append(getNext(source: i))
    }
    return result
  }
  
//  private func getNext(source: Int) -> Observable<[Contact]> {
//
//    //callbackQueue
//    //Callback queue. If nil - queue from provider initializer will be used.
//    //return provider.rx.request(.contacts(page: page), callbackQueue: DispatchQueue.main)
//
//    return provider.rx.request(.contacts(source: source))
//      .filterSuccessfulStatusCodes()
//      .map([Contact].self)
//      .asObservable()
//  }
  
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
