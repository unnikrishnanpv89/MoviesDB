//
//  VideoPlayer.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/02.
//

import SwiftUI
import WebKit

struct VideoPlayer: UIViewRepresentable {
    
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeUrl = URL(string: "https://www.youtube.com/embed/\(videoId)") else {return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeUrl))
    }
}
