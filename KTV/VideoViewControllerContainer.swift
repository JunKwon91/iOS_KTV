//
//  VideoViewControllerContainer.swift
//  KTV
//
//  Created by 박준권 on 12/26/23.
//

import Foundation

protocol VideoViewControllerContainer {
    var videoViewController: VideoViewController { get }
    func presentCurrentViewController()
}
