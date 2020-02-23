//
//  Contact.swift
//  Contacts
//
//  Created by Andrei Coder on 22.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import RealmSwift
import Realm

@objcMembers
class Contact: Object, Decodable {
  dynamic var id: String = ""
  dynamic var name: String = ""
  dynamic var phone: String = ""
  dynamic var height: Double = 0.0
  dynamic var biography: String = ""
  
  private dynamic var _temperament = Temperament.melancholic.rawValue
  dynamic var temperament: Temperament {
      get { return Temperament(rawValue: _temperament)! }
      set { _temperament = newValue.rawValue }
  }
  dynamic var educationPeriod: EducationPeriod? = nil

  override static func primaryKey() -> String? {
    return "id"
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case phone
    case height
    case biography
    case temperament
    case educationPeriod
  }
  
  required convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    phone = try container.decode(String.self, forKey: .phone)
    height = try container.decode(Double.self, forKey: .height)
    biography = try container.decode(String.self, forKey: .biography)
    _temperament = try container.decode(String.self, forKey: .temperament)
    //temperament = try container.decode(Temperament.self, forKey: .temperament)
    educationPeriod = try container.decode(EducationPeriod.self, forKey: .educationPeriod)
  }

//  required init() {
//    super.init()
//  }

//  required init(value: Any, schema: RLMSchema) {
//    super.init(value: value, schema: schema)
//  }
//
//  required init(realm: RLMRealm, schema: RLMObjectSchema) {
//    super.init(realm: realm, schema: schema)
//  }

}

//struct Contact: Decodable {
//  let id: String
//  let name: String
//  let phone: String
//  let height: Double
//  let biography: String
//  let temperament: Temperament
//  let educationPeriod: EducationPeriod
//}
