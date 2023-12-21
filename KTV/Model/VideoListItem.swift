//
//  VideoListItem.swift
//  KTV
//
//  Created by 박준권 on 12/21/23.
//

import Foundation

struct VideoListItem: Decodable {
    let playtime: Double
    let title: String
    let imageUrl: URL
    let videoId: Int
    let channel: String
}
