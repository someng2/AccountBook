//
//  NewAccountBookViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2022/12/06.
//

import Foundation
import FirebaseFirestore
import RxSwift

final class NewAccountBookViewModel {
    var accountBook: AccountBook
    var expenseMode =  BehaviorSubject<Bool>.init(value: true)
    var subcategory = BehaviorSubject<String>.init(value: SubCategory.expenseList[0].name)
    var contents = BehaviorSubject<String>.init(value: "")
    
    let bag = DisposeBag()
    let db = Firestore.firestore()
    var uid: String = ""
    
    init() {
        accountBook = AccountBook(category: "", subcategory: "", contents: "", price: 0, date: "")
        
        expenseMode
            .subscribe { [weak self] expenseMode in
                self?.accountBook.category = expenseMode ? "지출" : "수입"
            }.disposed(by: bag)
        
        subcategory
            .subscribe { [weak self] subcategory in
                self?.accountBook.subcategory = subcategory
            }.disposed(by: bag)
        
        contents
            .subscribe { [weak self] contents in
            self?.accountBook.contents = contents
        }.disposed(by: bag)
    }
    
    func saveNewData() {
        let data = self.accountBook
        let documentID = "\(data.id)"
        db.collection("User").document(uid).collection("AccountBook").document(documentID)
            .setData([
                "category" : data.category,
                "subcategory" : data.subcategory,
                "contents" : data.contents,
                "price" : data.price,
                "date" : data.date
            ]) { err in
                if let err = err {
                    print("---> Error saving data: \(err)")
                } else {
//                print("Firebase 저장 성공!")
            }
        }
    }
    
    
}
