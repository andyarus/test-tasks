//
//  ContactsEndpoints.swift
//  Contacts
//
//  Created by Andrei Coder on 19.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import Moya

public enum Contacts {
  case contacts(file: Int)
}

extension Contacts: TargetType {
  
  public var baseURL: URL { return URL(string: "https://raw.githubusercontent.com")! }
  
  public var path: String {
    switch self {
    case .contacts(let file):
      return String(format: "/SkbkonturMobile/mobile-test-ios/master/json/generated-%02d.json", file)
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .contacts:
      return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .contacts:
      return .requestPlain
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }
  
}

// MARK: - Response Handlers

public extension Moya.Response {
  
//  public func map<T: Decodable>(_ type: T.Type)
//    throws -> T {
//    return try type.decode(try self.mapJSON())
//  }
//  
//  public func map<T: Decodable>(_ type: [T.Type]) throws -> [T] {
//    return try Array<T>.decode(try self.mapJSON())
//  }
  
//    func mapNSArray() throws -> NSArray {
//        let any = try self.mapJSON()
//        guard let array = any as? NSArray else {
//            throw MoyaError.jsonMapping(self)
//        }
//        return array
//    }
}

