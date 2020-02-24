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
  private let provider = MoyaProvider<Contacts>() //(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
  private let databaseService = DatabaseService()
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
  
  //private let backgroundQueue = DispatchQueue(label: "background-queue", qos: .background)
  
  //let workQueue = DispatchQueue(label: "work-queue", qos: .background)
  //let workQueue = DispatchQueue(label: "work-queue", qos: .background)
  //let workQueue = DispatchQueue(label: "work-queue", qos: .background, attributes: .concurrent)
  
  // MARK: Public Properties
  
  //public let contacts = BehaviorRelay<[Contact]>(value: [])
  //public let contactsTest = PublishSubject<Result<[Contact], Error>>()
  public let contacts = PublishSubject<[Contact]>()
  public let error = PublishSubject<Error>()
  
  // MARK: Public Methods
  
  var testCounter: Int = 0
  
  public func loadData() {
    //workQueue.async { [unowned self] in
    DispatchQueue.global(qos: .background).async { [unowned self] in
      print("load data thread:\(Thread.current)")
      self.getContacts()
    }
  }
  
  public func getContacts() {
    self._contacts.removeAll()
    /// Load data from local storage
    if useLocalStorage() {
      self._contacts = self.databaseService.read()
      print("realmContacts.count:\(self._contacts.count)")
      print(self._contacts[0])
      print(self._contacts[0].temperament)
      
//      DispatchQueue.main.async {
//        self.contacts.onNext(self._contacts)
//      }
      
      self.contacts.onNext(self._contacts)
      
      return
    }
    
    /// Load data from network
    self.getMergedPages(forMax: 3)
      .subscribe(onNext: { contacts in
        print("onNext contacts.count:\(contacts.count) thread:\(Thread.current)")
        self._contacts.append(contentsOf: contacts)
      }, onError: { error in
        print("Error", error)
        //observer.on(.error(error))
        //self.contacts.onError(error)
        self.error.onNext(error)
        //self.contactsTest.onNext(.failure(error))
      }, onCompleted: {
        print("Completed on thread:\(Thread.current)")
        print("contacts:\(self._contacts.count)")

        if self.testCounter > 0 && self.testCounter % 2 == 0 {
          print("onError")
          let error = NSError(domain: "tmp error", code: 0, userInfo: nil)
          //self.contacts.onError(error)
          self.error.onNext(error)
          //self.contactsTest.onNext(.failure(error))
          
          //self.contacts.onNext(self._contacts)
        } else {
          print("onNext")
          self.contacts.onNext(self._contacts)
          //self.contactsTest.onNext(.success(self._contacts))
        }
        self.testCounter += 1
        
        
        print("wtf thread:\(Thread.current)")
        
        

          
        
        self.databaseService.update(with: self._contacts, qos: .background)
        //self.databaseService.update(with: self._contacts, in: self.backgroundQueue)
        self.lastUpdateTime = Date().timeIntervalSince1970
        
        
        


        
        
        
      }).disposed(by: self.disposeBag)
  }
  
//  public func getContacts() -> Observable<[Contact]> {
////    contacts.removeAll()
////    return getMergedPages(forMax: 3)
//
//    return Observable.create { observer in
//      self.contacts.removeAll()
//      self.getMergedPages(forMax: 3)
//        .subscribe(onNext: { contacts in
//          print("contacts.count:\(contacts.count)")
//          self.contacts.append(contentsOf: contacts)
//
//          observer.on(.next(contacts))
//        }, onError: { error in
//          print("Error", error)
//          observer.on(.error(error))
//        }, onCompleted: {
//          print("Completed")
//          print("contacts:\(self.contacts.count) \(self.contacts[0])")
//
//          //observer.on(.next(self.contacts))
//          self.contactsSubject.onNext(self.contacts)
//          observer.on(.completed)
//        }, onDisposed: {
//          print("Disposed")
//        }).disposed(by: self.disposeBag)
//
//      return Disposables.create()
//    }
//  }
  
//  public func getContacts() -> Single<Bool> {
//    return Single.create { [unowned self] single in
//      self.contacts.removeAll()
//      self.getMergedPages(forMax: 3)
//        .subscribe(onNext: { contacts in
//          print("contacts.count:\(contacts.count)")
//          self.contacts.append(contentsOf: contacts)
//        }, onError: { error in
//          print("Error", error)
//          single(.error(error))
//        }, onCompleted: {
//          print("Completed")
//          print("contacts:\(self.contacts.count) \(self.contacts[0])")
//
//          single(.success(true))
//          //single(.success(self.contacts))
//        }, onDisposed: {
//          print("Disposed")
//        }).disposed(by: self.disposeBag)
//
//      return Disposables.create()
//    }
//  }
  
  public func loadData(with filter: String) {
    let matchingСontacts = _contacts.filter { $0.name.hasPrefix(filter) }
    contacts.onNext(matchingСontacts)
  }
  
//  public func getContacts(with filter: String) -> Observable<[Contact]> {
//    let matchingСontacts = contacts.filter { $0.name.hasPrefix(filter) }//
//    return Observable.just(matchingСontacts)
//  }
  
  // MARK: Private Methods
  
  public func getMergedPages(forMax max: Int) -> Observable<[Contact]> {
    var pagesObservable = [Observable<[Contact]>]()
    for i in 1...max {
      pagesObservable.append(getNext(for: i))
    }
    
//    for i in 1...50 {
//      var page = i % 3
//      if page == 0 {
//        page = 1
//      }
//      pagesObservable.append(getNext(for: page))
//    }
    
    let pagesSequence = Observable.from(pagesObservable)
    return pagesSequence.merge()
  }
  
  private func getNext(for page: Int) -> Observable<[Contact]> {
    return provider.rx.request(.contacts(page: page))
      .filterSuccessfulStatusCodes()
      .map([Contact].self)
      .asObservable()
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
