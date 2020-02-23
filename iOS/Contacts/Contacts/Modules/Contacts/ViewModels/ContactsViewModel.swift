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
  
  private var disposeBag = DisposeBag()
  private let provider = MoyaProvider<Contacts>()
  //let provider = MoyaProvider<Contacts>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
  private let databaseService = DatabaseService()
  
  // MARK: Public Properties
  
  public var contacts = [Contact]()
  public let contactsSubject = PublishSubject<[Contact]>()
  
  // MARK: Public Methods
  
  public func loadData() {
    getContacts()
  }
  
  public func getContacts() {
    self.contacts.removeAll()
    self.getMergedPages(forMax: 3)
      .subscribe(onNext: { contacts in
        print("contacts.count:\(contacts.count)")
        self.contacts.append(contentsOf: contacts)
        
        //observer.on(.next(contacts))
      }, onError: { error in
        print("Error", error)
        //observer.on(.error(error))
      }, onCompleted: {
        print("Completed")
        print("contacts:\(self.contacts.count) \(self.contacts[0])")
        
        print("self.contacts[0].temperament:\(self.contacts[1].temperament)")

        //observer.on(.next(self.contacts))
        self.contactsSubject.onNext(self.contacts)
        //observer.on(.completed)
        
        
//        do {
//
//        let realm = try Realm()
//        print(realm.configuration.fileURL?.absoluteString ?? "")
        
        let contacts = self.databaseService.read()
        print("realmContacts:\(contacts.count)")
        
        
        
        let startTime = DispatchTime.now()
        
        self.databaseService.update(with: self.contacts)
        
        let endTime = DispatchTime.now()
        let diffTimeNs = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let diffTimeS = Double(diffTimeNs) / 1_000_000_000

        print("diffTime:\(diffTimeS) s diffTime:\(diffTimeNs) ns")
        
      }, onDisposed: {
        print("Disposed")
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
    let matchingСontacts = contacts.filter { $0.name.hasPrefix(filter) }
    contactsSubject.onNext(matchingСontacts)
  }
  
//  public func getContacts(with filter: String) -> Observable<[Contact]> {
//    let matchingСontacts = contacts.filter { $0.name.hasPrefix(filter) }//
//    return Observable.just(matchingСontacts)
//  }
  
  // MARK: Private Methods
  
  private func getMergedPages(forMax max: Int) -> Observable<[Contact]> {
    var pagesObservable = [Observable<[Contact]>]()
    for i in 1...max {
      pagesObservable.append(getNext(for: i))
    }    
    let pagesSequence = Observable.from(pagesObservable)
    return pagesSequence.merge()
  }
  
  private func getNext(for page: Int) -> Observable<[Contact]> {
    return provider.rx.request(.contacts(page: 1))
      .filterSuccessfulStatusCodes()
      .map([Contact].self)
      .asObservable()
  }
  
}
