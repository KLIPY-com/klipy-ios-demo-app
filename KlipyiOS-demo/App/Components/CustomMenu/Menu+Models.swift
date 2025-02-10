//
//  Menu+Models.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

enum MenuAction: Equatable {
  case send
  case report(ReportReason)
}

enum ReportReason: String, CaseIterable {
  case violence = "Violence"
  case pornography = "Pornography"
  case childAbuse = "Child Abuse"
  case copyright = "Copyright"
  case other = "Other"
  
  var icon: String {
    switch self {
    case .violence: return "exclamationmark.triangle.fill"
    case .pornography: return "exclamationmark.shield.fill"
    case .childAbuse: return "person.fill.xmark"
    case .copyright: return "exclamationmark.bubble"
    case .other: return "exclamationmark.circle.fill"
    }
  }
}
