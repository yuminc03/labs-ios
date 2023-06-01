//
//  WebVC.swift
//  LabsProject
//
//  Created by Yumin Chu on 2023/06/02.
//

import UIKit
import WebKit

import SnapKit

final class WebVC: LabsVC {
    
    private var webView = WKWebView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadHTML(url: "Test.html")
        evaluateJS()
    }
    
    private func loadHTML(url: String) {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    private func evaluateJS() {
        webView.evaluateJavaScript("colorHeader()")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(webView)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)
        
        let userScript = WKUserScript(source: "redHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContent = WKUserContentController()
        userContent.addUserScript(userScript)
        
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension WebVC: WKUIDelegate {
    
    
}

extension WebVC: WKNavigationDelegate {
    
    
}

extension WebVC: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            print(message.body)
        }
    }
}
