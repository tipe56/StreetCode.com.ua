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
//        guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else { }
//        do {
//            let data = try Data(contentsOf: url)
//            webView.load(data, mimeType: <#T##String#>, characterEncodingName: <#T##String#>, baseURL: <#T##URL#>)
//        } catch {
//            print(error.localizedDescription)
//        }
        
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //
    }
}


struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
//            ActivityIndicator()
        }
    }
}

#Preview {
    LoadingView()
}
