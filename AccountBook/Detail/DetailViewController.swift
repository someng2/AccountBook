//
//  DetailViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/10.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var detailVM: DetailViewModel!
    var listVM: AccountBookListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        do { let item = try detailVM.accountBook.value()
            closeButton.tintColor = .black
            iconImageView.image = getIcon(item)
            iconImageView.tintColor = .white
            circleView.layer.cornerRadius = self.circleView.layer.bounds.width / 2
            circleView.clipsToBounds = true
            circleView.backgroundColor = UIColor(named: "SecondaryOrange")
            categoryLabel.text = "\(item.category) 정보"
            dateLabel.text = item.date
            subcategoryLabel.text = item.subcategory
            contentsLabel.text = item.contents
            priceLabel.text = formatPrice(item.price)
            editButton.layer.cornerRadius = 30
            editButton.layer.borderWidth = 3
            editButton.layer.borderColor = UIColor(named: "SecondaryOrange")?.cgColor
        } catch(let error) {
            print(error)
        }
    }
    
    private func formatPrice(_ price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if let result = numberFormatter.string(from: NSNumber(value: price)) {
            return result
        } else {
            return "가격 형식 오류!"
        }
    }
    
    private func getIcon(_ item: AccountBook) -> UIImage {
        if item.category == "지출" {
            return SubCategory.expenseList.filter { $0.name == item.subcategory
            }[0].icon
        } else {
            return SubCategory.revenueList.filter { $0.name == item.subcategory
            }[0].icon
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        // TODO: 수정기능 구현
        detailVM.deleteData()
        let data = try! listVM.list.value()
        let id = try! detailVM.accountBook.value().id
        listVM.list.onNext(data.filter{ $0.id != id })
        self.dismiss(animated: true)
    }
    
    
}
