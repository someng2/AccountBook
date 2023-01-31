//
//  DetailViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/10.
//

import Foundation
import RxSwift
import FirebaseFirestore

final class DetailViewModel {
    
    // Data -> Output
    let accountBook: BehaviorSubject<AccountBook>
    let uid: String
    
    init(accountBook: AccountBook, uid: String) {
        self.accountBook = BehaviorSubject(value: accountBook)
        self.uid = uid
    }
    
    func deleteData() {
        let db = Firestore.firestore()
        let ref = db
            .collection("User").document(uid)
            .collection("AccountBook").document(try! accountBook.value().id)
        
        ref.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("데이터 삭제 성공!")
            }
        }
    }
    
}
