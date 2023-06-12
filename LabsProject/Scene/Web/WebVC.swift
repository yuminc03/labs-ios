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
//        evaluateJS()
    }
    
    private func loadHTML(url: String) {
        guard let filePath = Bundle.main.path(forResource: "Test", ofType: "html") else { return }
        let siteUrl = URL(fileURLWithPath: filePath)
        let urlRequest = URLRequest(url: siteUrl)
        webView.load(urlRequest)
    }
    
//    private func evaluateJS() {
//        webView.evaluateJavaScript("callNative()")
//    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        let userScript = WKUserScript(source: "colorHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
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

extension WebVC: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        let alert = UIAlertController(title: "Title", message: message, preferredStyle: .alert)
        let buttonAction = UIAlertAction(title: "Close", style: .default, handler: { action in completionHandler()
        })
        alert.addAction(buttonAction)
        present(alert, animated: true, completion: nil)
    }
}

extension WebVC: WKNavigationDelegate {
    
    
}

extension WebVC: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            print("==================")
            print(message.body)
            print("==================")
        }
    }
}
