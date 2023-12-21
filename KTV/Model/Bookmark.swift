//
//  Bookmark.swift
//  KTV
//
//  Created by 박준권 on 12/21/23.
//

import Foundation

struct Bookmark: Decodable {
    
    let channels: [Item]
}

extension Bookmark {
    
    struct Item: Decodable {
        let channel: String
        let channelId: Int
        let thumbnail: URL
    }
}
