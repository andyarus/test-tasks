//
//  DatabaseService.swift
//  Contacts
//
//  Created by Andrei Coder on 23.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift

class DatabaseService {
  
  // MARK: Private Properties
  
  private let disposeBag = DisposeBag()
  private var realm: Realm!
  
  // MARK: Init
  
  init() {
    do {
      realm = try Realm()
      print("Realm configuration url:\(realm.configuration.fileURL?.absoluteString ?? "")")
    } catch let error as NSError {
      print("Error init Realm", error)
    }
  }
  
  // MARK: Public Methods
  
  public func create(with contacts: [Contact]) {
    do {
      try realm.write {
        realm.add(contacts, update: .all)
      }
    } catch let error as NSError {
      print("Error on Realm create", error)
    }
  }
  
  public func read() -> [Contact] {
    let contacts = realm.objects(Contact.self)
    print("contacts:\(contacts.count)")
    
    return Array(contacts)
  }
  
  public func update(with contacts: [Contact]) {
    do {
      try realm.write {
        realm.add(contacts, update: .modified)
      }
    } catch let error as NSError {
      print("Error on Realm update", error)
    }
  }
  
  public func delete() {
    do {
      try realm.write {
        realm.deleteAll()
      }
    } catch let error as NSError {
      print("Error on Realm deleteAll", error)
    }
  }
  
}
