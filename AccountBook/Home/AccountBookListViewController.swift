//
//  AccountBookListViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import UIKit
import DTZFloatingActionButton
import Firebase
import FirebaseFirestore
import RxSwift

class AccountBookListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Item = AnyHashable
    enum Section: Int {
        case summary
        case list
    }
    let viewModel: AccountBookListViewModel = AccountBookListViewModel()
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureCollectionView()
        viewModel.getUid()
        bind()
        addFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadFirebaseData(dateFilter: try! viewModel.dateFilter.value())
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "살림의 왕 🤓"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = UIColor(named: "SecondaryNavy")
        navigationItem.backBarButtonItem = backButton
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let profileImage = UIImage(systemName: "person.crop.circle")
        let logOutButton = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(profileButtonTapped))
        logOutButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = logOutButton
    }
    
    @objc func profileButtonTapped() {
        let vc = ProfileViewController()
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
        collectionView.delegate = self
    }
    
    private func addFloatingButton() {
        let actionButton = DTZFloatingActionButton()
        actionButton.handler = {
            button in
            let sb = UIStoryboard(name: "NewAccountBook", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewAccountBookViewController") as! NewAccountBookViewController
            vc.vm.uid = try! self.viewModel.uid.value()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionButton.isScrollView = true
        actionButton.buttonColor = UIColor(named: "PrimaryBlue")!
        self.view.addSubview(actionButton)
    }
    
    private func bind() {
        
        viewModel.uid
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] uid in
                print("---> uid = \(uid)")
                self?.viewModel.fetchDateFilter()
            }.disposed(by: bag)
        
        viewModel.dateFilter
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] filter in
//                print("---> new date filter: \(filter)")
                self?.viewModel.loadFirebaseData(dateFilter: filter)
            }.disposed(by: bag)
        
        viewModel.summary
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] summary in
//                print("---> summary = \(summary)")
                self?.applySnapshot(items: [summary], section: .summary)
            }.disposed(by: bag)
        
        viewModel.list
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] list in
//                print("---> list = \(list)")
                let revenueList = list.filter { $0.category == "수입"}
                let totalRevenue = revenueList.map({$0.price}).reduce(0, +)
                let expenseList = list.filter { $0.category == "지출"}
                let totalExpense = expenseList.map({$0.price}).reduce(0, +)
                self?.viewModel.summary.onNext(Summary(revenue: totalRevenue, expense: totalExpense, sum: totalRevenue-totalExpense))
                self?.applySnapshot(items: list, section: .list)
            }.disposed(by: bag)
        
        viewModel.selectedItem
            .compactMap{ $0 }   // nil이 아닐 때
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] accountBook in
                let sb = UIStoryboard(name: "Detail", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.viewModel = DetailViewModel(accountBook: accountBook)
//                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }.disposed(by: bag)
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

extension AccountBookListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let accountBook = viewModel.list[indexPath.item]
        if indexPath.section == 1 {
            viewModel.didSelect(at: indexPath)
        }
    }
}
