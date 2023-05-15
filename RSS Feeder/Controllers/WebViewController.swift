//
//  WebViewController.swift
//  RSS Feeder
//
//  Created by muhammad.alfarisi on 14/05/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var feedItem = FeedItem(title: "", description: "", link: "")
    
    func setFeedItem(feedItem: FeedItem) {
        self.feedItem = feedItem
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load((URLRequest(url: URL(string: feedItem.link)!)))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
