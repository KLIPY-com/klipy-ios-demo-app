//
//  KlipyWebView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 07.02.25.
//

import UIKit
@preconcurrency import WebKit
import SwiftUI

public class KlipyWebView: UIView {
  private var webView: WKWebView!
  
  public init() {
    super.init(frame: .zero)
    
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.frame = frame
    
    webView.navigationDelegate = self
    webView.isOpaque = true
    
    addSubview(webView)
    
    layoutWebView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func loadURL(url: URL) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  public func loadHTMLString(htmlString: String) {
    webView.loadHTMLString(htmlString, baseURL: nil)
  }
  
  private func layoutWebView() {
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: self.topAnchor),
      webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}

extension KlipyWebView: WKNavigationDelegate {
  public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard let url = navigationAction.request.url else {
      decisionHandler(.allow)
      return
    }
    
    if navigationAction.navigationType == .linkActivated {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
}
