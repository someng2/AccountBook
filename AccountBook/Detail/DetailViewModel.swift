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
    
    init(accountBook: AccountBook) {
        self.accountBook = BehaviorSubject(value: accountBook)
        print("accountBook: \(accountBook)")
    }
    
    func deleteData() {
        let db = Firestore.firestore()
//        db.collection("cities").document("DC").delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
    }
    
}
