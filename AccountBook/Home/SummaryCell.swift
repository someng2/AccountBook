//
//  SummaryCell.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import UIKit

class SummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var monthLabel: UIButton!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var revenueView: UIView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var expenseView: UIView!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var sumView: UIView!
    
    func configure() {
        monthLabel.tintColor = UIColor(named: "PrimaryBlue")
        revenueLabel.text = "300,000원"
        expenseLabel.text = "286.670원"
        sumLabel.text = "13,330원"
        revenueView.layer.cornerRadius = 10
        revenueView.backgroundColor = UIColor(named: "PrimaryGreen")
        expenseView.layer.cornerRadius = 10
        expenseView.backgroundColor = UIColor(named: "PrimaryRed")
        sumView.layer.borderWidth = 3
        sumView.layer.cornerRadius = 10
        
    }
    
}
