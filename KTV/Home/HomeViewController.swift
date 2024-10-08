//
//  HomeViewController.swift
//  KTV
//
//  Created by Lecture on 2023/09/08.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let homeViewModel: HomeViewModel = .init()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.bindViewModel()
        self.homeViewModel.requestData()
    }
    
    private func setupCollectionView() {
        self.collectionView.register(
            UINib(nibName: "HomeHeaderView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderView.identifier
        )
        
        self.collectionView.register(
            UINib(nibName: "HomeRankingHeaderView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeRankingHeaderView.identifier
        )
        
        self.collectionView.register(
            UINib(nibName: "HomeFooterView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: HomeFooterView.identifier
        )
        
        self.collectionView.register(
            UINib(nibName: "HomeVideoCell", bundle: .main),
            forCellWithReuseIdentifier: HomeVideoCell.identifier
        )
        
        self.collectionView.register(
            UINib(nibName: "HomeRecommendContainerCell", bundle: .main),
            forCellWithReuseIdentifier: HomeRecommendContainerCell.identifier
        )
        
        //        self.collectionView.register(
        //            UINib(nibName: HomeRankingContainerCell.identifier, bundle: .main),
        //            forCellWithReuseIdentifier: HomeRankingContainerCell.identifier
        //        )
        //
        //        self.collectionView.register(
        //            UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: .main),
        //            forCellWithReuseIdentifier: HomeRecentWatchContainerCell.identifier
        //        )
        
        self.collectionView.register(
            UINib(nibName: HomeRankingItemCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRankingItemCell.identifier
        )
        
        self.collectionView.register(
            UINib(nibName: HomeRecentWatchItemCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeRecentWatchItemCell.identifier
        )
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.init(sectionProvider: { section, _ in
            self.makeSection(section)
        })
        
        self.collectionView.isHidden = true
    }
    
    private func makeSection(_ section: Int) -> NSCollectionLayoutSection? {
        guard let section = HomeSection(rawValue: section) else {
            return nil
        }
        
        let itemSpace: CGFloat = 21
        let inset: NSDirectionalEdgeInsets = .init(top: 0, leading: 21, bottom: 21, trailing: 21)
        
        switch section {
        case .header:
            return self.makeHeaderSection()
        case .video:
            return self.makeVideoSection(itemSpace, inset)
        case .ranking:
            return self.makeRankingSection(itemSpace, inset)
        case .recentWatch:
            return self.makeRecentWatchSection(itemSpace, inset)
        case .recommend:
            return self.makeRecommendSection(inset)
        case .footer:
            return self.makeFooterSection()
        }
    }
    
    fileprivate func makeHeaderSection() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeHeaderView.height)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [
                .init(
                    layoutSize: .init(widthDimension: .absolute(1.0), heightDimension: .absolute(0.1))
                )
            ]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem.init(
                layoutSize: layoutSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        return section
    }
    
    fileprivate func makeVideoSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeVideoCell.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = inset
        section.interGroupSpacing = itemSpace
        
        return section
    }
    
    fileprivate func makeRankingSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection? {
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeRankingHeaderView.height)
        )
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(HomeRankingItemCell.size.width),
            heightDimension: .absolute(HomeRankingItemCell.size.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(HomeRankingItemCell.size.width),
                heightDimension: .absolute(265)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpace
        section.contentInsets = inset
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerLayoutSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    fileprivate func makeRecentWatchSection(_ itemSpace: CGFloat, _ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(HomeRecentWatchItemCell.itemSize.width),
            heightDimension: .absolute(HomeRecentWatchItemCell.itemSize.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(HomeRecentWatchItemCell.itemSize.width),
                heightDimension: .absolute(189)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpace
        section.contentInsets = inset
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    fileprivate func makeRecommendSection(_ inset: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension:
                    .absolute(
                        HomeRecommendContainerCell.height(viewModel: self.homeViewModel.recommendViewModel)
                    )
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = inset
        
        return section
    }
    
    fileprivate func makeFooterSection() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(HomeFooterView.height)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSize,
            subitems: [.init(
                layoutSize: .init(
                    widthDimension: .absolute(1.0),
                    heightDimension: .absolute(1.0)
                )
            )]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: layoutSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
        ]
        
        return section
    }
    
    private func bindViewModel() {
        self.homeViewModel.dataChanged = { [weak self] in
            self?.collectionView.isHidden = false
            self?.collectionView.reloadData()
        }
    }
    
    private func presentVideoViewController() {
        if let vc = (self.tabBarController as? VideoViewControllerContainer)?.videoViewController {
            (self.tabBarController as? VideoViewControllerContainer)?.presentCurrentViewController()
        } else {
            let vc = VideoViewController()
            vc.delegate = self.tabBarController as? VIdeoViewControllerDelegate
            self.present(vc, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        guard let section = HomeSection(rawValue: section) else {
    //            return .zero
    //        }
    //
    //        switch section {
    //        case .header:
    //            return CGSize(width: collectionView.frame.width, height: HomeHeaderView.height)
    //        case .ranking:
    //            return CGSize(width: collectionView.frame.width, height: HomeRankingHeaderView.height)
    //        case .video, .recentWatch, .recommend, .footer:
    //            return .zero
    //        }
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        guard let section = HomeSection(rawValue: section) else {
    //            return .zero
    //        }
    //
    //        switch section {
    //        case .footer:
    //            return CGSize(width: collectionView.frame.width, height: HomeFooterView.height)
    //        case .header, .ranking, .video, .recentWatch, .recommend:
    //            return .zero
    //        }
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        guard let section = HomeSection(rawValue: section) else {
    //            return .zero
    //        }
    //
    //        return self.insetForSection(section)
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        guard let section = HomeSection(rawValue: section) else {
    //            return 0
    //        }
    //
    //        switch section {
    //        case .header, .footer:
    //            return 0
    //        case .video, .ranking, .recentWatch, .recommend:
    //            return 21
    //        }
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        guard let section = HomeSection(rawValue: indexPath.section) else {
    //            return .zero
    //        }
    //
    //        let inset = self.insetForSection(section)
    //        let width = collectionView.frame.width - inset.left - inset.right
    //
    //        switch section {
    //        case .header, .footer:
    //            return .zero
    //        case .video:
    //            return .init(width: width, height: HomeVideoCell.height)
    //        case .ranking:
    //            return .init(width: width, height: HomeRankingContainerCell.height)
    //        case .recentWatch:
    //            return .init(width: width, height: HomeRecentWatchContainerCell.height)
    //        case .recommend:
    //            return .init(
    //                width: width,
    //                height: HomeRecommendContainerCell.height(viewModel: self.homeViewModel.recommendViewModel)
    //            )
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .header, .footer, .recommend :
            return
        case .video, .ranking, .recentWatch:
            self.presentVideoViewController()
        }
    }
    
    private func insetForSection(_ section:HomeSection) -> UIEdgeInsets {
        switch section {
        case .header, .footer:
            return .zero
        case .video, .ranking, .recentWatch, .recommend:
            return .init(top: 0, left: 21, bottom: 21, right: 21)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .header:
            return 0
        case .video:
            return self.homeViewModel.home?.videos.count ?? 0
        case .ranking:
            return self.homeViewModel.home?.rankings.count ?? 0
        case .recentWatch:
            return self.homeViewModel.home?.recents.count ?? 0
        case .recommend:
            return 1
        case .footer:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return .init()
        }
        
        switch section {
        case .header:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeHeaderView.identifier,
                for: indexPath
            )
        case .ranking:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeRankingHeaderView.identifier,
                for: indexPath
            )
        case .footer:
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeFooterView.identifier,
                for: indexPath
            )
        case .video, .recentWatch, .recommend:
            return .init()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath)
        }
        
        switch section {
        case .header, .footer:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: "empty",
                for: indexPath
            )
            
        case .video:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeVideoCell.identifier,
                for: indexPath
            )
            if let cell = cell as? HomeVideoCell,
               let data = self.homeViewModel.home?.videos[indexPath.item] {
                cell.setData(data)
            }
            return cell
            
        case .ranking:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRankingItemCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? HomeRankingItemCell,
               let data = self.homeViewModel.home?.rankings[indexPath.item] {
                cell.setData(data, rank: indexPath.item + 1)
            }
            return cell
            
        case .recentWatch:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRecentWatchItemCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? HomeRecentWatchItemCell,
               let data = self.homeViewModel.home?.recents[indexPath.item] {
                cell.setData(data)
            }
            return cell
            
        case .recommend:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeRecommendContainerCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? HomeRecommendContainerCell {
                cell.delegate = self
                cell.setViewModel(self.homeViewModel.recommendViewModel)
            }
            return cell
        }
    }
}



extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        print("home recommend cell did select item at \(index)")
        self.presentVideoViewController()
    }
    
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
        // tableView vs collectionView
        // tableView: 정말 간단한 화면을 만들때 사용
        // collectionView: 유연하고 복잡한 화면을 만들때 사용
        // 둘 중 collectionView를 사용하는 것을 권장한다.
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension HomeViewController: HomeRankingContainerCellDelegate {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
        print("home ranking did select at \(index)")
        self.presentVideoViewController()
    }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
        print("home recent watch did select at \(index)")
        self.presentVideoViewController()
    }
}

// MARK: - Table View
//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        HomeSection.allCases.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let section = HomeSection(rawValue: section) else {
//            return 0
//        }
//        switch section {
//        case .header:
//            return 1
//        case .video:
//            return 2
//        case .recommend:
//            return 1
//        case .footer:
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let section = HomeSection(rawValue: indexPath.section) else {
//            return 0
//        }
//        switch section {
//        case .header:
//            return HomeHeaderCell.height
//        case .video:
//            return HomeVideoCell.height
//        case .recommend:
//            return HomeRecommendContainerCell.height
//        case .footer:
//            return HomeFooterCell.height
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let section = HomeSection(rawValue: indexPath.section) else {
//            return tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
//        }
//
//        switch section {
//        case .header:
//            return tableView.dequeueReusableCell(
//                withIdentifier: HomeHeaderCell.identifier,
//                for: indexPath
//            )
//        case .video:
//            return tableView.dequeueReusableCell(
//                withIdentifier: HomeVideoCell.identifier,
//                for: indexPath
//            )
//        case .recommend:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: HomeRecommendContainerCell.identifier,
//                for: indexPath
//            )
//
//            (cell as? HomeRecommendContainerCell)?.delegate = self
//
//            return cell
//        case .footer:
//            return tableView.dequeueReusableCell(
//                withIdentifier: HomeFooterCell.identifier,
//                for: indexPath
//            )
//        }
//    }
//}
