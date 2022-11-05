//
//  MovieViewController.swift
//  SolutionApp
//
//  Created by GENKI Mac on 2021/12/12.
//

import UIKit
import WebKit

class MovieViewController: UIViewController,WKUIDelegate{
    
    private var webView: WKWebView!
    
    //受け取った動画のURL
    var get_video_url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //=========================
        // 動画再生 処理　↓
        //========================
        
        // WKWebViewを生成
        webView = WKWebView(frame:CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height))
        
        // URL設定
        let urlString = get_video_url
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        let url = NSURL(string: encodedUrlString!)
        let request = NSURLRequest(url: url! as URL)
        
        // 動画再生設定
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        webView = WKWebView(frame:CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height), configuration: config)
        webView.load(request as URLRequest)
        
        // 本体回転時
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(webView)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

