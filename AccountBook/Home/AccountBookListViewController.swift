//
//  AccountBookListViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import UIKit
import Combine
import DTZFloatingActionButton
import Firebase
import FirebaseFirestore

class AccountBookListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Item = AnyHashable
    enum Section: Int {
        case summary
        case list
    }
    let viewModel: AccountBookListViewModel = AccountBookListViewModel()
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "가계부"
        bind()
        configureCollectionView()
        viewModel.fetchAccountBooks()
        addFloatingButton()
        
//        emailCheck(nickname: "someng")
//        emailCheck(nickname: "som")
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return nil }
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
    
    private func addFloatingButton() {
        let actionButton = DTZFloatingActionButton()
        actionButton.handler = {
            button in
            let sb = UIStoryboard(name: "NewAccountBook", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewAccountBookViewController") as! NewAccountBookViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionButton.isScrollView = true
        actionButton.buttonColor = UIColor(named: "PrimaryBlue")!
        self.view.addSubview(actionButton)
    }
    
    private func bind() {
        
        viewModel.$dateFilter
            .receive(on: RunLoop.main)
            .sink { filter in
                print("---> new date filter: \(filter)")
                self.viewModel.list = AccountBook.tempList.filter {
                    $0.monthlyIdentifier == filter
                }.sorted(by: { $0.hourIdentifier > $1.hourIdentifier })
                
                print("---> list date filter: \(self.viewModel.list)")
            }.store(in: &subscriptions)
        
        viewModel.$summary
            .receive(on: RunLoop.main)
            .sink { summary in
                print("---> summary = \(summary)")
                self.applySnapshot(items: [summary], section: .summary)
            }.store(in: &subscriptions)
        
        viewModel.$list
            .receive(on: RunLoop.main)
            .sink { list in
                let revenueList = list.filter { $0.category == "수입"}
                let totalRevenue = revenueList.map({$0.price}).reduce(0, +)
                let expenseList = list.filter { $0.category == "지출"}
                let totalExpense = expenseList.map({$0.price}).reduce(0, +)
                self.viewModel.summary = Summary(revenue: totalRevenue, expense: totalExpense, sum: totalRevenue-totalExpense)
                //                self.viewModel.dic = Dictionary(grouping: list, by: { $0.monthlyIdentifier })
                self.applySnapshot(items: list, section: .list)
            }.store(in: &subscriptions)
    }
    
    private func applySnapshot(items: [Item], section: Section) {
        var snapshot = datasource.snapshot()
        let previousItems = snapshot.itemIdentifiers(inSection: section)
        snapshot.deleteItems(previousItems)
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot)
    }
    
    private func configureCell(for section: Section, item: Item, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        switch section{
        case .summary:
            if let summary = item as? Summary {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
                cell.configure(item: summary, vm: viewModel)
                return cell
            } else {
                return nil
            }
            
        case .list:
            if let accountBook = item as? AccountBook {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountBookListCell", for: indexPath) as! AccountBookListCell
                cell.configure(item: accountBook)
                return cell
            }
            else {
                return nil
            }
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
    
    var firestore: Firestore!
    let db = Firestore.firestore()
    
    /*
     이메일 중복 검사
     */
    func emailCheck(nickname: String){
        var result = false
        
        let userDB = db.collection("User")
        // 입력한 이메일이 있는지 확인 쿼리
        let query = userDB.whereField("nickname", isEqualTo: nickname)
        query.getDocuments() { (qs, err) in
            
            if qs!.documents.isEmpty {
                print("\(nickname): 닉네임 중복안됨")
                result = true
            } else {
                print("\(nickname): 닉네임 이미 존재!")
                result = false
            }
        }
        
//        return result
    }
    
}
