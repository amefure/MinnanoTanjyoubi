//
//  UICustomWebView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/14.
//

import SwiftUI
import UIKit
import WebKit

// WebViewを表示するためのUikitView
struct UICustomWebView: UIViewRepresentable {
    private var webView: WKWebView
    var url: URL

    init(url: URL) {
        self.url = url
        webView = WKWebView()
    }

    func makeUIView(context _: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.load(request)
    }
}

extension UICustomWebView {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var webView: UICustomWebView

        init(_ webView: UICustomWebView) {
            self.webView = webView
        }

        func webView(_ webView: WKWebView, createWebViewWith _: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures _: WKWindowFeatures) -> WKWebView? {
            // target_blankでも開けるようにする：WKUIDelegate
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }

        func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError _: Error) {}

        // ページ表示が完了するたびに呼ばれる
        func webView(_: WKWebView, didFinish _: WKNavigation!) {}
    }
}

extension UICustomWebView {
    func goBack() {
        webView.goBack()
    }

    func goForward() {
        webView.goForward()
    }

    func openBrowser() {
        guard let url = webView.url else { return }
        // Safariで起動する
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    func reload() {
        webView.reload()
    }
}
