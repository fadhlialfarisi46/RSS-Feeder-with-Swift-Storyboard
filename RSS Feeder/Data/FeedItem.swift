//
//  FeedItem.swift
//  RSS Feeder
//
//  Created by muhammad.alfarisi on 14/05/23.
//

import Foundation

class FeedItem {
    var title: String
    var description: String
    var link: String
    
    init(title: String, description: String, link: String) {
        self.title = title
        self.description = description
        self.link = link
    }
}
