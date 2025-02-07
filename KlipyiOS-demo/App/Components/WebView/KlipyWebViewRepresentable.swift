//
//  KlipyWebViewRepresentable.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 07.02.25.
//

import SwiftUI

struct KlipyWebViewRepresentable: UIViewRepresentable {
  let url: URL?
  let htmlString: String?
  
  init(url: URL? = nil, htmlString: String? = nil) {
    self.url = url
    self.htmlString = htmlString
  }
  
  func makeUIView(context: Context) -> KlipyWebView {
    KlipyWebView()
  }
  
  func updateUIView(_ webView: KlipyWebView, context: Context) {
    if let url = url {
      webView.loadURL(url: url)
    } else if let htmlString = htmlString {
      webView.loadHTMLString(htmlString: htmlString)
    }
  }
}
