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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        let compeleteButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.typeFinished(sender:)))
        compeleteButtonItem.tintColor = UIColor(named: "SecondaryNavy")
        self.navigationItem.rightBarButtonItem = compeleteButtonItem
        
        contentTextView.text = vm.contents.isEmpty ? "내용을 입력하세요 (12자 이내)" : vm.contents
        contentTextView.textColor = vm.contents.isEmpty ? UIColor.lightGray : .black
        contentTextView.layer.borderWidth = 3.0
        contentTextView.layer.cornerRadius = 15
        contentTextView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        contentTextView.layer.borderColor = UIColor(named: "SecondaryOrange")?.cgColor
        contentTextView.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    @objc func typeFinished(sender: UIBarButtonItem) {
        if contentTextView.text.count > 12 {
            showToast(message: "12자 이내의 내용을 입력해주세요!")
            return
        }
        
        vm.contents = (contentTextView.text == "내용을 입력하세요 (12자 이내)") ? "" : contentTextView.text
        print("---> accountBook: \(vm.accountBook)")
        navigationController?.popViewController(animated: true)
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
            contentTextView.text = "내용을 입력하세요 (12자 이내)"
            contentTextView.textColor = UIColor.lightGray
        }
    }
}
