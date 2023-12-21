//
//  FavoriteViewModel.swift
//  KTV
//
//  Created by 박준권 on 12/21/23.
//

import Foundation

@MainActor class FavoriteViewModel {
    private(set) var favorite: Favorite?
    var dataChanged: (() -> Void)?
    
    func request() {
        Task {
            do {
                let favorite = try await DataLoader.load(url: URLDefines.favorite, for: Favorite.self)
                self.favorite = favorite
                self.dataChanged?()
            } catch {
                print("favorite load failed \(error.localizedDescription)")
            }
        }
    }
}
