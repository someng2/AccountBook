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
        setupNavigationBar()
        bind()
        configureCollectionView()
        viewModel.getUid()
        addFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadFirebaseData(dateFilter: viewModel.dateFilter)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "살림의 왕 🤓"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = UIColor(named: "SecondaryNavy")
        navigationItem.backBarButtonItem = backButton
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let logOutImage = UIImage(named: "logout")
        let logOutButton = UIBarButtonItem(image: logOutImage, style: .plain, target: self, action: #selector(logOutButtonTapped))
        logOutButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = logOutButton
    }
    
    @objc func logOutButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "Uid")
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
            vc.vm.uid = self.viewModel.uid
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionButton.isScrollView = true
        actionButton.buttonColor = UIColor(named: "PrimaryBlue")!
        self.view.addSubview(actionButton)
    }
    
    private func bind() {
        
        viewModel.$uid
            .receive(on: RunLoop.main)
            .sink { uid in
                print("---> uid = \(uid)")
                self.viewModel.fetchDateFilter()
            }.store(in: &subscriptions)
        
        viewModel.$dateFilter
            .receive(on: RunLoop.main)
            .sink { filter in
                print("---> new date filter: \(filter)")
                self.viewModel.loadFirebaseData(dateFilter: filter)
            }.store(in: &subscriptions)
        
        viewModel.$summary
            .receive(on: RunLoop.main)
            .sink { summary in
//                print("---> summary = \(summary)")
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
    
}
