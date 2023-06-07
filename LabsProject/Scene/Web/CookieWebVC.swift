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
    private var httpCookies: [HTTPCookie] = []
    private let domain = "https://yuminc03.github.io"
    private let path = "/first_bootstrap_portpolio"
    private let injectScriptInit: String = """
                                       var isSet = false;
                                       
                                       function getCookie(name) {
                                            var cookieValue = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
                                            return cookieValue? cookieValue[2] : null;
                                       }
                                       
                                       function deleteAllCookies() {
                                           var cookies = document.cookie.split(";");
                                       
                                           for (var i = 0; i < cookies.length; i++) {
                                               var cookie = cookies[i];
                                               var eqPos = cookie.indexOf("=");
                                               var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
                                               document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
                                           }
                                       }
                                       
                                       """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadHTML(url: domain + path)
    }
    
    private func loadHTML(url: String) {
        if let url = URL(string: url) {
            var urlRequest = URLRequest(url: url)
            let headers = HTTPCookie.requestHeaderFields(with: httpCookies)
            for (name, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: name)
            }
            webView.load(urlRequest)
        }
    }
    
//    private func evaluateJS() {
//        webView.evaluateJavaScript("callNative()")
//    }
    
    private func setCookies() {
        guard let token = setupCookie(name: "token", value: "aaaaaaaaaaa", path: path, domain: domain) else {
            return
        }
        
        guard let userName = setupCookie(name: "userName", value: "yumin", path: path, domain: domain) else {
            return
        }
        
        httpCookies = [token, userName]
        print("🍪🍪 token: \(token.value), userName: \(userName.value)")
    }
    
    ///cookie 만들고 cookie를 return
    private func setupCookie(name: String, value: String, path: String, domain: String) -> HTTPCookie? {
        var cookieProperties = [HTTPCookiePropertyKey : Any]()
        cookieProperties[.name] = name
        cookieProperties[.value] = value
        cookieProperties[.path] = path
        cookieProperties[.domain] = domain
        let newCookie = HTTPCookie(properties: cookieProperties)
        return newCookie
    }
    
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
