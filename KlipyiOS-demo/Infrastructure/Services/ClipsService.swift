//
//  ClipsService.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import Moya
import Foundation

public enum ClipsService {
  case trending(page: Int, perPage: Int, customerId: String, locale: String)
  case search(query: String, page: Int, perPage: Int, customerId: String, locale: String)
  case categories
  case recent(customerId: String, page: Int, perPage: Int)
  case hideFromRecent(customerId: String, slug: String)
  case view(slug: String, customerId: String)
  case share(slug: String, customerId: String)
  case report(slug: String, customerId: String, reason: String)
}

extension ClipsService: KlipyTargetType {
  public var path: String {
    switch self {
    case .trending:
      return PathComponent.clips + PathComponent.trending
      
    case .search:
      return PathComponent.clips + PathComponent.search
      
    case .categories:
      return PathComponent.clips + PathComponent.categories
      
    case .recent(let customerId, _, _):
      return PathComponent.clips + PathComponent.recent + "/\(customerId)"
      
    case .hideFromRecent(let customerId, _):
      return PathComponent.clips + PathComponent.recent + "/\(customerId)"
      
    case .view(let slug, _):
      return PathComponent.clips + PathComponent.view + "/\(slug)"
      
    case .share(let slug, _):
      return PathComponent.clips + PathComponent.share + "/\(slug)"
      
    case .report(let slug, _, _):
      return PathComponent.clips + PathComponent.report + "/\(slug)"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .hideFromRecent:
      return .delete
    case .view, .share, .report:
      return .post
    default:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .trending(let page, let perPage, let customerId, let locale):
      return .requestParameters(parameters: [
        "page": page,
        "per_page": perPage,
        "customer_id": customerId,
        "locale": locale
      ].withAdParameters(), encoding: URLEncoding.default)
      
    case .search(let query, let page, let perPage, let customerId, let locale):
      return .requestParameters(parameters: [
        "q": query,
        "page": page,
        "per_page": perPage,
        "customer_id": customerId,
        "locale": locale
      ].withAdParameters(), encoding: URLEncoding.default)
      
    case .categories:
      return .requestPlain
      
    case .recent(_, let page, let perPage):
      return .requestParameters(parameters: [
        "page": page,
        "per_page": perPage
      ].withAdParameters(), encoding: URLEncoding.default)
      
    case .hideFromRecent(_, let slug):
      return .requestParameters(parameters: [
        "slug": slug
      ].withAdParameters(), encoding: URLEncoding.default)
      
    case .view(_, let customerId):
      return .requestParameters(
        parameters: ["customer_id": customerId],
        encoding: JSONEncoding.default
      )
      
    case .share(_, let customerId):
      return .requestParameters(
        parameters: ["customer_id": customerId],
        encoding: JSONEncoding.default
      )
      
    case .report(_, let customerId, let reason):
      return .requestParameters(
        parameters: [
          "customer_id": customerId,
          "reason": reason
        ],
        encoding: JSONEncoding.default
      )
    }
  }
}
