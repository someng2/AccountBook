//
//  NewContentViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2022/12/06.
//

import UIKit

class NewContentViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    
    var vm: NewAccountBookViewModel!
    
//    init(viewModel: NewAccountBookViewModel) {
//        self.vm = viewModel
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        setupUI()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "완료", style: .done, target: self, action: #selector(self.action(sender:)))
    }
    
    private func setupUI() {
        contentTextView.text = vm.contents.isEmpty ? "내용을 입력하세요." : vm.contents
        contentTextView.textColor = vm.contents.isEmpty ? UIColor.lightGray : .black
        contentTextView.layer.borderWidth = 2.0
        contentTextView.layer.cornerRadius = 15
        contentTextView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        contentTextView.layer.borderColor = UIColor(named: "SecondaryNavy")?.cgColor
        contentTextView.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    @objc func action(sender: UIBarButtonItem) {
        vm.contents = contentTextView.text
//        print("---> accountBook: \(vm.accountBook)")
        navigationController?.popViewController(animated: true)
    }
}

extension NewContentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // TextColor로 처리합니다. text로 처리하게 된다면 placeholder와 같은걸 써버리면 동작이 이상하겠죠?
        if contentTextView.textColor == UIColor.lightGray {
            contentTextView.text = nil // 텍스트를 날려줌
            contentTextView.textColor = UIColor.black
        }
        
    }
    // UITextView의 placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = "내용을 입력하세요"
            contentTextView.textColor = UIColor.lightGray
        }
    }
}
