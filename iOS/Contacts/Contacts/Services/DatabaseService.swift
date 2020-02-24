//
//  DatabaseService.swift
//  Contacts
//
//  Created by Andrei Coder on 23.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import RealmSwift
//import RxRealm
import RxSwift

class DatabaseService {
  
  // MARK: Private Properties
  
  //private let disposeBag = DisposeBag()
  //private var realm: Realm!
  
  // MARK: Init
  
  init() {
//    do {
//      realm = try Realm()
//      print("Realm configuration url:\(realm.configuration.fileURL?.absoluteString ?? "")")
//    } catch let error as NSError {
//      print("Error init Realm", error)
//    }
  }
  
  // MARK: Public Methods
  
  public func create(with contacts: [Contact]) {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(contacts, update: .all)
      }
    } catch let error as NSError {
      print("Error on Realm create", error)
    }
  }
  
  public func read() -> [Contact] {
    let realm = try! Realm()
    let contacts = realm.objects(Contact.self)
    return Array(contacts)
  }
  
  /// Update in the same thred
  public func update(with contacts: [Contact]) {
    
    //delete()
    
    do {
      print()
      print("update")
      let realm = try Realm()
      try realm.write {
        print("write")
        //realm.beginWrite()
        realm.add(contacts, update: .modified)
        //try realm.commitWrite()
      }
    } catch let error as NSError {
      print("Error on Realm update", error)
    }
  }
  
  /// Update in other thread
  public func update(with contacts: [Contact], qos: DispatchQoS.QoSClass, reduceMemoryUsage: Bool = false) {
    DispatchQueue.global(qos: qos).async {
      autoreleasepool {
        do {
          
          let startTime = DispatchTime.now()
          
          /// Thread safety in context current thread (just copy contact created in other thread or will be crash)
          if reduceMemoryUsage {
            /// Don't allocate copy of array contacts - possible reduce memory usage (but still high memory consumption on transaction)
            let realm = try Realm()
            realm.beginWrite()
            for contact in contacts {
              let contactThreadSafeCopy = Contact(value: contact)
              realm.add(contactThreadSafeCopy, update: .modified)
            }
            try realm.commitWrite()
          } else {
            var contactsThreadSafe = [Contact]()
            for contact in contacts {
              let contactThreadSafeCopy = Contact(value: contact)
              contactsThreadSafe.append(contactThreadSafeCopy)
            }
            let realm = try Realm()
            try realm.write {
              realm.add(contactsThreadSafe, update: .modified)
            }
          }
          
          
          
          let endTime = DispatchTime.now()
          let diffTimeNs = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
          let diffTimeS = Double(diffTimeNs) / 1_000_000_000
          print("diffTime:\(diffTimeS) s diffTime:\(diffTimeNs) ns")
          
          
          
        } catch let error as NSError {
          print("Error on Realm update in different queue", error)
        }
      } // autoreleasepool
    } // queue.async
  }
  
  public func delete() {
    do {
      let realm = try Realm()
      try realm.write {
        realm.deleteAll()
      }
    } catch let error as NSError {
      print("Error on Realm delete", error)
    }
  }
  
}

// MARK: - Background Thread Processing

//extension Realm {
//  
//  /// https://realm.io/docs/cookbook/swift/object-to-background/
//  
//  func writeAsync<T : ThreadConfined>(
//    _ object: T,
//    errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return },
//    block: @escaping ((Realm, T?) -> Void))
//  {
//    let wrappedObject = ThreadSafeReference(to: object)
//    let config = self.configuration
//    DispatchQueue.global(qos: .background).async {
//      autoreleasepool {
//        do {
//          let realm = try Realm(configuration: config)
//          let resolveObject = realm.resolve(wrappedObject)
//
//          try realm.write {
//            block(realm, resolveObject)
//          }
//        }
//        catch {
//          errorHandler(error)
//        }
//      }
//    }
//  }
//  
//  func writeArrayAsync<T: Object>(objects: [T]) {
//    for object in objects {
//      self.writeAsync(object) { (realm, itemToSave) in
//        guard itemToSave != nil else { return }
//        realm.add(itemToSave!, update: .modified)
//      }
//    }
//  }
//  
//}
