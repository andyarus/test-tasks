//
//  ContactsEndpoints.swift
//  Contacts
//
//  Created by Andrei Coder on 19.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Moya

public enum Contacts {
  case getContacts(file: Int)
}

extension Contacts: TargetType {
  
  public var baseURL: URL { return URL(string: "https://raw.githubusercontent.com")! }
  
  public var path: String {
    switch self {
    case .getContacts(let file):
      return String(format: "/SkbkonturMobile/mobile-test-ios/master/json/generated-%02d.json", file)
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .getContacts:
      return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .getContacts:
      return .requestPlain
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public var headers: [String: String]? {
    return nil
  }
  
}
