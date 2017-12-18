//
//  ViewController.swift
//  Youtube Player
//
//  Created by Antonio da Silva on 03/04/2017.
//  Copyright © 2017 Antonio da Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - Constants
    
    let appGroupName = "br.com.tntstudios.youtubeplayer"
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // registering the notification
        
        NotificationCenter.default.addObserver(self, selector: #selector(onEnterFullScreen),
                                               name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCloseFullScreen),
                                               name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)
        
        webView.delegate = self
        webView.allowsInlineMediaPlayback = false
        
        loadYoutubeIframe(youtubeVideoId: "kBmHYr_dUZc") // your Youtube video ID.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url {
            
            // user is trying to get away of the application.
            if url.absoluteString.contains("https://www.youtube.com/watch") {
                return false
            }
            
            if url.scheme == appGroupName {
                
                if let playerState = url.absoluteString.components(separatedBy: "=").last {
                    
                    // iframe API reference: https://developers.google.com/youtube/iframe_api_reference
                    
                    // -1 – unstarted
                    // 0 – ended
                    // 1 – playing
                    // 2 – paused
                    // 3 – buffering
                    // 5 – video cued
                    // 6 - ready
                    
                    switch playerState {
                    case "-1":
                        print("video State: unstarted")
                        break
                    case "0":
                        print("video State: ended")
                    case "1":
                        print("video State: playing")
                    case "2":
                        print("video State: paused")
                    case "3":
                        print("video State: buffering")
                    case "5":
                        print("video State: video cued")
                    case "6":
                        print("video State: ready")
                        break
                    default:
                        print("video State: LOL")
                    }
                    
                }
                
            }
        }
        return true
    }
    
    // MARK: - Helpers
    
    func loadYoutubeIframe(youtubeVideoId: String) {
        
        let html =
            "<html>" +
                "<body style='margin: 0;'>" +
                "<script type='text/javascript' src='http://www.youtube.com/iframe_api'></script>" +
                "<script type='text/javascript'> " +
                "   function onYouTubeIframeAPIReady() {" +
                "      ytplayer = new YT.Player('playerId',{events:{'onReady': onPlayerReady, 'onStateChange': onPlayerStateChange}}) " +
                "   } " +
                "   function onPlayerReady(a) {" +
                "       window.location = 'br.com.tntstudios.youtubeplayer://state=6'; " +
                "   }" +
                "   function onPlayerStateChange(d) {" +
                "       window.location = 'br.com.tntstudios.youtubeplayer://state=' + d.data; " +
                "   }" +
                "</script>" +
                "<div style='justify-content: center; align-items: center; display: flex; height: 100%;'>" +
                "   <iframe id='playerId' type='text/html' width='100%' height='100%' src='https://www.youtube.com/embed/\(youtubeVideoId)?" +
                "enablejsapi=1&rel=0&playsinline=0&autoplay=0&showinfo=0&modestbranding=1' frameborder='0'>" +
                "</div>" +
                "</body>" +
        "</html>"
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    @objc func onEnterFullScreen() {
        print("Enter fullscreen")
    }
    
    @objc func onCloseFullScreen() {
        print("Exit fullscreen")
    }

}

