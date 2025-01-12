//
//  AsyncMoyaRequestWrapper.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//


import Foundation
import Moya

class AsyncMoyaRequestWrapper {
  typealias MoyaContinuation = CheckedContinuation<Result<Response, MoyaError>, Never>

  var performRequest: (MoyaContinuation) -> (any Moya.Cancellable)?
  var cancellable: (any Moya.Cancellable)?

  init(_ performRequest: @escaping (MoyaContinuation) -> (any Moya.Cancellable)?) {
    self.performRequest = performRequest
  }

  func perform(continuation: MoyaContinuation) {
    cancellable = performRequest(continuation)
  }

  func cancel() {
    cancellable?.cancel()
  }
}
