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
  let provider = MoyaProvider<Contacts>()
  //let provider = MoyaProvider<Contacts>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
  
  // MARK: Public Properties
  
  public var contacts = [Contact]()
  
  // MARK: Public Methods
  
  public func getContacts() -> Single<Bool> {
    return Single.create { [unowned self] single in
      self.contacts.removeAll()
      self.getMergedPages(forMax: 3)
        .subscribe(onNext: { contacts in
          print("contacts.count:\(contacts.count)")
          self.contacts.append(contentsOf: contacts)
        }, onError: { error in
          print("Error", error)
          single(.error(error))
        }, onCompleted: {
          print("Completed")
          print("contacts:\(self.contacts.count) \(self.contacts[0])")
          
          single(.success(true))
          //single(.success(self.contacts))
        }, onDisposed: {
          print("Disposed")
        }).disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
  
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
