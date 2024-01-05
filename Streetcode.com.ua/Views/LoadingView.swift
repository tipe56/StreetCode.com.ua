//
//  LoadingView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            do {
                let data = try Data(contentsOf: url)
                webView.load(
                    data,
                    mimeType: "image/gif",
                    characterEncodingName: "UTF-8",
                    baseURL: url.deletingLastPathComponent())
            } catch {
                print(error.localizedDescription)
            }
        }
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
//        uiView.reload()
    }
}


struct LoadingView: View {
    
    var gifBundlename: String
    
    var body: some View {
        ZStack {
            GifImage(name: gifBundlename)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    LoadingView(gifBundlename: "Logo-animation_40")
}
