//
//  NewAccountBookViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2022/12/04.
//

import UIKit
import Combine

class NewAccountBookViewController: UIViewController{
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceMode: UIView!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var revenueButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var expenseMode = true
    var vm: NewAccountBookViewModel = NewAccountBookViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.becomeFirstResponder()
        setupUI()
        priceTextField.delegate = self
        
        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCategoryTap(sender:)))
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContentTap(sender:)))
        categoryView.addGestureRecognizer(categoryTapGesture)
        contentView.addGestureRecognizer(contentTapGesture)
        bind()
    }
    
    private func bind() {
        vm.$contents
            .sink { contents in
                print("---> contents : \(contents)")
                self.contentLabel.text = (contents == "" ? "내용을 입력하세요." : contents)
            }.store(in: &subscriptions)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.contentLabel.text = vm.accountBook.contents
//    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        
        priceTextField.text = "0"
        priceTextField.borderStyle = .none
        priceTextField.endFloatingCursor()
        expenseButton.layer.borderWidth = 2
        expenseButton.tintColor = UIColor(named: "PrimaryRed")
        expenseButton.layer.borderColor = UIColor(named: "PrimaryRed")?.cgColor
        expenseButton.layer.cornerRadius = 10
        
        revenueButton.layer.borderWidth = 1
        revenueButton.tintColor = .gray
        revenueButton.layer.borderColor = UIColor(ciColor: .gray).cgColor
        revenueButton.layer.cornerRadius = 10
        
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        
        contentLabel.text = vm.accountBook.contents.isEmpty ? "내용을 입력하세요." : vm.accountBook.contents
    }
    
    @IBAction func pressedExpenseButton(_ sender: Any) {
        expenseMode = true
        updateUI()
    }
    
    @IBAction func pressedRevenueButton(_ sender: Any) {
        expenseMode = false
        updateUI()
    }
    
    private func updateUI() {
        priceMode.backgroundColor = expenseMode ? UIColor(named: "PrimaryRed") : UIColor(named: "PrimaryBlue")
        expenseButton.layer.borderWidth = expenseMode ? 2 : 1
        expenseButton.tintColor = expenseMode ? UIColor(named: "PrimaryRed") : .gray
        expenseButton.layer.borderColor = expenseMode ? UIColor(named: "PrimaryRed")?.cgColor : UIColor(ciColor: .gray).cgColor
        expenseButton.titleLabel?.font = .systemFont(ofSize: 16, weight: expenseMode ? .bold : .regular)
        
        revenueButton.layer.borderWidth = expenseMode ? 1 : 2
        revenueButton.tintColor = expenseMode ? .gray : UIColor(named: "PrimaryBlue")
        revenueButton.layer.borderColor = expenseMode ? UIColor(ciColor: .gray).cgColor : UIColor(named: "PrimaryBlue")?.cgColor
        revenueButton.titleLabel?.font = .systemFont(ofSize: 16, weight: expenseMode ? .regular : .bold)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @objc func handleCategoryTap(sender: UITapGestureRecognizer) {
        if sender.view == categoryView {
            print("category view !")
        }
        
    }
    @objc func handleContentTap(sender: UITapGestureRecognizer) {
        if sender.view == contentView {
            let sb = UIStoryboard(name: "NewAccountBook", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewContentViewController") as! NewContentViewController
            vc.vm = self.vm
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension NewAccountBookViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        priceTextField.tintColor = .gray
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 0
        formatter.decimalSeparator = "."                                  // Adapt to your case
        formatter.groupingSeparator = ","                                 // Adapt to your case
        
        // The complete string if string were added at the end
        // Here we only insert figures at the end
        
        // Let us first remove extra groupingSeparator we may have introduced to find the number
        let completeString = textField.text!.replacingOccurrences(of: formatter.groupingSeparator, with: "") + string
        
        var backSpace = false
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                backSpace = true
            }
        }
        if string == "" && backSpace {           // backspace inserts nothing, but we need to accept it.
            return true
        }
        if string == "-" && textField.text! == "" {  // Accept leading minus
            return true
        }
        
        guard let value = Double(completeString) else { return false } // No double ; We do not insert
        
        let formattedNumber = formatter.string(from: NSNumber(value: value)) ?? ""
        textField.text = formattedNumber // We update the textField, adding typed character
        
        return string == formatter.decimalSeparator // No need to insert the typed char: we've done just above, unless we just typed separator
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.tintColor = UIColor.clear
        return true
    }
}
