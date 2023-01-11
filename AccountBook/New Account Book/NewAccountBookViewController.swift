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
    @IBOutlet weak var subcategoryView: UIView!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    var vm: NewAccountBookViewModel = NewAccountBookViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.becomeFirstResponder()
        setupUI()
        priceTextField.delegate = self
        
        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCategoryTap(sender:)))
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleContentTap(sender:)))
        subcategoryView.addGestureRecognizer(categoryTapGesture)
        contentView.addGestureRecognizer(contentTapGesture)
        bind()
    }

    private func bind() {
        vm.$expenseMode
            .sink { mode in
                self.updateUI(mode)
            }.store(in: &subscriptions)
        
        vm.$contents
            .sink { contents in
                print("---> contents : \(contents)")
                self.contentLabel.text = (contents.isEmpty ? "내용을 입력하세요." : contents)
            }.store(in: &subscriptions)
        
        vm.$subcategory
            .sink { subcategory in
                print("---> subcategory: \(subcategory)")
                self.subcategoryLabel.text = subcategory
            }.store(in: &subscriptions)
    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButton.tintColor = UIColor(named: "SecondaryNavy")
        navigationItem.backBarButtonItem = backButton
        
        let saveButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(self.saveButtonTapped(sender:)))
        saveButtonItem.tintColor = UIColor(named: "SecondaryNavy")
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
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
        subcategoryLabel.text = vm.expenseMode ? SubCategory.expenseList[0].name : SubCategory.revenueList[0].name
    }
    
    @IBAction func pressedExpenseButton(_ sender: Any) {
        vm.expenseMode = true
    }
    
    @IBAction func pressedRevenueButton(_ sender: Any) {
        vm.expenseMode = false
    }
    
    @objc func saveButtonTapped(sender: UIBarButtonItem) {
        let priceText = priceTextField.text?.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        if let price = Int(priceText!) {
            vm.accountBook.price = price
            if price == 0 {
                showToast(message: "가격을 입력해주세요!")
                return
            }
        }
        let contents = vm.accountBook.contents
        if contents.isEmpty {
            showToast(message: "내용을 입력해주세요!")
            return
        }
        vm.accountBook.date = datePicker.date.convertedDate
        vm.saveNewData()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 15.0, weight: .bold)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 140, y: self.view.frame.size.height-120, width: 280, height: 50))
        toastLabel.backgroundColor = UIColor(named: "SecondaryOrange")
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    private func updateUI(_ expenseMode: Bool) {
        priceMode.backgroundColor = expenseMode ? UIColor(named: "PrimaryRed") : UIColor(named: "PrimaryBlue")
        expenseButton.layer.borderWidth = expenseMode ? 2 : 1
        expenseButton.tintColor = expenseMode ? UIColor(named: "PrimaryRed") : .gray
        expenseButton.layer.borderColor = expenseMode ? UIColor(named: "PrimaryRed")?.cgColor : UIColor(ciColor: .gray).cgColor
        expenseButton.titleLabel?.font = .systemFont(ofSize: 16, weight: expenseMode ? .bold : .regular)
        
        revenueButton.layer.borderWidth = expenseMode ? 1 : 2
        revenueButton.tintColor = expenseMode ? .gray : UIColor(named: "PrimaryBlue")
        revenueButton.layer.borderColor = expenseMode ? UIColor(ciColor: .gray).cgColor : UIColor(named: "PrimaryBlue")?.cgColor
        revenueButton.titleLabel?.font = .systemFont(ofSize: 16, weight: expenseMode ? .regular : .bold)
        
        vm.subcategory = expenseMode ? SubCategory.expenseList[0].name : SubCategory.revenueList[0].name
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @objc func handleCategoryTap(sender: UITapGestureRecognizer) {
        if sender.view == subcategoryView {
            let sb = UIStoryboard(name: "NewAccountBook", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewSubcategoryViewController") as! NewSubcategoryViewController
            vc.vm = self.vm
            self.navigationController?.pushViewController(vc, animated: true)
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

extension Date {
    var convertedDate: String {
        let dateFormatter = DateFormatter()

        let dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: self)

        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

        dateFormatter.dateFormat = dateFormat
        if let sourceDate = dateFormatter.date(from: formattedDate) {
            return dateFormatter.string(from: sourceDate)
        }

        return ""
    }
}

