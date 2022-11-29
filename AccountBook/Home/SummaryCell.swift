//
//  SummaryCell.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import UIKit
import MonthYearPicker

class SummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var revenueView: UIView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var expenseView: UIView!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var sumView: UIView!
    
    var availableYear: [Int] = []
    var allMonth: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    var selectedYear = 0
    var selectedMonth = 0
    var todayYear = "0"
    var todayMonth = "0"
    
    func configure(item: Summary) {
        yearTextField.text = "🗓  \(formatDate(Date()))"
        yearTextField.tintColor = .clear
        yearTextField.backgroundColor = UIColor(named: "PrimaryBlue")
        yearTextField.textColor = .white
        revenueLabel.text = "\(formatNumber(item.revenue))원"
        expenseLabel.text = "\(formatNumber(item.expense))원"
        sumLabel.text = "\(formatNumber(item.sum))원"
        revenueView.layer.cornerRadius = 10
        revenueView.backgroundColor = UIColor(named: "PrimaryGreen")
        expenseView.layer.cornerRadius = 10
        expenseView.backgroundColor = UIColor(named: "PrimaryRed")
        sumView.layer.borderWidth = 3
        sumView.layer.cornerRadius = 10
        
        addDatePicker()
    }
    
    func addDatePicker() {
        let picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (bounds.height - 216) / 2), size: CGSize(width: bounds.width, height: 216)))
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        //        button.backgroundColor = .green
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor(named: "PrimaryBlue"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        picker.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: picker.trailingAnchor, constant: -40),
            button.topAnchor.constraint(equalTo: picker.topAnchor, constant: 5)
        ])
        
        yearTextField.inputView = picker
    }
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        yearTextField.text = "🗓  \(formatDate(picker.date))"
    }
    
    @objc func buttonAction(sender: UIButton!) {
        yearTextField.resignFirstResponder()
        
        // 리스트 업데이트
    }
    
    private func formatNumber(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let result = formatter.string(from: NSNumber(integerLiteral: price)) ?? ""
        return result
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        
        return formatter.string(from: date)
    }
    
}
