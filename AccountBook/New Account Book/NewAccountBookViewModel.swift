//
//  NewAccountBookViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2022/12/06.
//

import Foundation
import Combine
import FirebaseFirestore

final class NewAccountBookViewModel {
    @Published var accountBook: AccountBook
    @Published var expenseMode: Bool = true
    @Published var subcategory: String = SubCategory.expenseList[0].name
    @Published var contents: String = ""
    
    var subscriptions = Set<AnyCancellable>()
    let db = Firestore.firestore()
    
    init() {
        accountBook = AccountBook(category: "", subcategory: "", contents: "", price: 0, date: "")
        
        $expenseMode.sink { expenseMode in
            self.accountBook.category = expenseMode ? "지출" : "수입"
        }.store(in: &subscriptions)
        
        $subcategory.sink { subcategory in
            self.accountBook.subcategory = subcategory
        }.store(in: &subscriptions)
        
        $contents.sink { contents in
            self.accountBook.contents = contents
        }.store(in: &subscriptions)
    }
    
    func saveNewData() {
        let data = self.accountBook
        let documentID = "\(data.id)"
        db.collection("User").document("user1").collection("AccountBook").document(documentID)
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
