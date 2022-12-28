//
//  NewSubcategoryViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2022/12/27.
//

import UIKit

class NewSubcategoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var vm: NewAccountBookViewModel!
    let list: [SubCategory] = SubCategory.list
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var chosenIndex: IndexPath!
    
    typealias Item = SubCategory
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as? SubCategoryCell else {
                return nil
            }
            cell.configure(item)
            if (item.name == self.vm.subcategory) {
                cell.setupDefaultBackground()
                self.chosenIndex = indexPath
            }
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

extension NewSubcategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subcategory = list[indexPath.item]
        print(">>> selected index: \(indexPath.item) -> \(subcategory.name)")
        collectionView.cellForItem(at: self.chosenIndex)?.backgroundColor = UIColor(named: "LightOrange")
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(named: "SecondaryOrange")
        self.chosenIndex = indexPath
        vm.subcategory = subcategory.name
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
