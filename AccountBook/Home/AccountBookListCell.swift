//
//  AccountBookListCell.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/23.
//

import UIKit

class AccountBookListCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var view: UIView!
    
    func configure(item: AccountBook) {
        self.dateLabel.text = item.date
        self.contentsLabel.text = item.contents
        self.priceLabel.text = "\(formatNumber(item.price))원"
        self.priceLabel.textColor = item.category == "수입" ? UIColor(named: "PrimaryGreen") : UIColor(named: "PrimaryRed")
        view.layer.cornerRadius = 15
        self.iconImageView.image = getIcon(item)
        self.iconImageView.tintColor = UIColor(named: "SecondaryNavy")
        self.circleView.layer.cornerRadius = self.circleView.layer.bounds.width / 2
        self.circleView.clipsToBounds = true
        self.circleView.backgroundColor = .white
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
    
    private func formatNumber(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let result = formatter.string(from: NSNumber(integerLiteral: price)) ?? ""
        return result
    }
    
//    private func formatDate(_ date: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//
//        let date = formatter.date(from: date) ?? Date()
//        formatter.dateFormat = "yyyy.MM.dd"
//        let result = formatter.string(from: date)
//
//        return result
//    }

}
