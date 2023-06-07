//
//  CookieWebVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/08.
//

import UIKit
import WebKit

import SnapKit

final class CookieWebVC: LabsVC {
    
    private var webView = WKWebView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadHTML(url: "https://yuminc03.github.io/first_bootstrap_portpolio")
    }
    
    private func loadHTML(url: String) {
        if let url = URL(string: url) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
//    private func evaluateJS() {
//        webView.evaluateJavaScript("callNative()")
//    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension CookieWebVC: WKUIDelegate {
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Swift.Void
    ) {
        let alert = UIAlertController(title: "Title", message: message, preferredStyle: .alert)
        let buttonAction = UIAlertAction(title: "Close", style: .default, handler: { action in completionHandler()
        })
        alert.addAction(buttonAction)
        present(alert, animated: true, completion: nil)
    }
}

extension CookieWebVC: WKNavigationDelegate {
    
    
}

extension CookieWebVC: WKScriptMessageHandler {
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        
    }
}
