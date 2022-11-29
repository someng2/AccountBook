//
//  AccountBookListViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import UIKit
import Combine

class AccountBookListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Item = AccountBook
    enum Section: Int {
        case summary
        case list
    }
    let viewModel: AccountBookListViewModel = AccountBookListViewModel()
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureCollectionView()
        viewModel.fetchAccountBooks()
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return nil}
            let cell = self.configureCell(for: section, item: item, collectionView: collectionView, indexPath: indexPath)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.summary, .list])
        snapshot.appendItems([], toSection: .summary)
        snapshot.appendItems([] , toSection: .list)
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
    }
    
    private func bind() {
        //TODO: viewModel Combine으로 가져오기
        viewModel.$list
            .receive(on: RunLoop.main)
            .sink { list in
//                self.viewModel.dic = Dictionary(grouping: list, by: { $0.monthlyIdentifier })
                print("sorted list = \(list.sorted(by: { $0.monthlyIdentifier > $1.monthlyIdentifier }))")
                self.applySnapshot(items: list.sorted(by: { $0.monthlyIdentifier > $1.monthlyIdentifier }), section: .list)
            }.store(in: &subscriptions)
    }
    
    private func applySnapshot(items: [Item], section: Section) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot)
    }
    
    private func configureCell(for section: Section, item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        switch section{
        case .summary:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
            cell.configure()
            return cell
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountBookListCell", for: indexPath) as! AccountBookListCell
            cell.configure(item: item)
            return cell
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    

}
